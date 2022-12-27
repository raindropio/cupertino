import SwiftUI
import Backport

public struct DisclosureSection<C: View, M: View, A: View> {
    @State private var more = false
    
    var label: Text
    var isExpanded: Bool
    var toggle: () -> Void
    var content: () -> C
    var menu: () -> M
    var action: () -> A
    
    public init<S: StringProtocol>(
        _ label: S,
        isExpanded: Bool,
        toggle: @escaping () -> Void,
        content: @escaping () -> C,
        menu: @escaping () -> M,
        action: @escaping () -> A
    ) {
        self.label = Text(label)
        self.isExpanded = isExpanded
        self.toggle = toggle
        self.content = content
        self.menu = menu
        self.action = action
    }
}

extension DisclosureSection where A == EmptyView {
    public init<S: StringProtocol>(
        _ label: S,
        isExpanded: Bool,
        toggle: @escaping () -> Void,
        content: @escaping () -> C,
        @ViewBuilder menu: @escaping () -> M
    ) {
        self.label = Text(label)
        self.isExpanded = isExpanded
        self.toggle = toggle
        self.content = content
        self.menu = menu
        self.action = { A() }
    }
}

extension DisclosureSection {
    var toggler: some View {
        Button(action: toggle) {
            Label(
                isExpanded ? "Hide" : "Show",
                systemImage: isExpanded ? "eye.slash" : "chevron.right"
            )
        }
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 20) {
            label
            
            Spacer()
            
            if isExpanded {
                action()

                Button {
                    more.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                }
                    .tint(.secondary)
                    .confirmationDialog("Menu", isPresented: $more, titleVisibility: .hidden) {
                        menu()
                        
                        Section {
                            toggler
                        }
                    }
            }
            
            if !isExpanded {
                toggler
                    .labelStyle(.iconOnly)
            }
        }
            .backport.fontWeight(.semibold)
            .imageScale(.large)
    }
}

extension DisclosureSection: View {
    public var body: some View {
        Section(content: {
            if isExpanded {
                content()
            }
        }, header: header)
            #if os(macOS)
            .collapsible(false)
            #endif
    }
}
