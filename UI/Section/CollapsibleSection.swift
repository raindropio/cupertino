import SwiftUI

public struct CollapsibleSection<C: View, T: View, A: View> {
    var title: LocalizedStringKey
    var collapsed: Bool
    var content: () -> C
    var toggle: () -> T
    var actions: () -> A
    
    public init(
        _ title: LocalizedStringKey,
        _ collapsed: Bool = false,
        content: @escaping () -> C,
        toggle: @escaping () -> T,
        @ViewBuilder actions: @escaping () -> A
    ) {
        self.title = title
        self.collapsed = collapsed
        self.content = content
        self.toggle = toggle
        self.actions = actions
    }
}

extension CollapsibleSection: View {
    public var body: some View {
        Section {
            if !collapsed {
                content()
            }
        } header: {
            HStack {
                Text(title)
                
                Spacer()
                
                ZStack(alignment: .trailing) {
                    ControlGroup {
                        actions()
                    }
                        .controlGroupStyle(ActionsStyle())
                        .opacity(collapsed ? 0 : 1)
                    
                    toggle()
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                        .controlSize(.mini)
                        .opacity(collapsed ? 1 : 0)
                }
            }
        }
            #if os(macOS)
            .collapsible(false)
            #endif
    }
}

extension CollapsibleSection {
    //increases all buttons/menus tap area
    struct ActionsStyle: ControlGroupStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            HStack(spacing: 0) {
                configuration.content
            }
                .fontWeight(.medium)
                .buttonStyle(.bordered)
                .tint(.black.opacity(0.00001))
                .foregroundColor(.accentColor)
                .padding(.trailing, -16)
        }
    }
}
