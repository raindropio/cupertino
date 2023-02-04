import SwiftUI

//MARK: - Init
public func DisclosureSection<L: StringProtocol, C: View>(
    _ label: L,
    isExpanded: Binding<Bool>,
    content: @escaping () -> C
) -> some View {
    _DisclosureSection(
        isExpanded: isExpanded.wrappedValue,
        content: content
    ) {
        _SectionHeader(isExpanded: isExpanded, label: Text(label)) {}
    }
}

public func DisclosureSection<L: StringProtocol, C: View, A: View>(
    _ label: L,
    isExpanded: Binding<Bool>,
    content: @escaping () -> C,
    actions: @escaping () -> A
) -> some View {
    _DisclosureSection(
        isExpanded: isExpanded.wrappedValue,
        content: content
    ) {
        _SectionHeader(isExpanded: isExpanded, label: Text(label), actions: actions)
    }
}

public func DisclosureSection<L: StringProtocol, C: View, A: View>(
    _ label: L,
    isExpanded: Bool,
    toggle: @escaping () -> Void,
    content: @escaping () -> C,
    actions: @escaping () -> A
) -> some View {
    _DisclosureSection(
        isExpanded: isExpanded,
        content: content
    ) {
        _SectionHeader(
            isExpanded: .init { isExpanded } set: { _ in toggle() },
            label: Text(label),
            actions: actions
        )
    }
}

//MARK: - Implementation
fileprivate struct _DisclosureSection<C: View, H: View>: View {
    var isExpanded: Bool
    var content: () -> C
    var header: () -> H
    
    var body: some View {
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

fileprivate struct _SectionHeader<L: View, A: View>: View {
    @Environment(\.headerProminence) private var prominence
    
    @Binding var isExpanded: Bool
    var label: L
    @ViewBuilder var actions: () -> A
    
    var body: some View {
        HStack(spacing: 10) {
            label
                ._onButtonGesture(pressing: nil) {
                    isExpanded.toggle()
                }
            
            Button {
                isExpanded.toggle()
            } label: {
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .fontWeight(.semibold)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
                .tint(.gray)
            
            Spacer()
            
            if isExpanded {
                actions()
            }
        }
            .lineLimit(1)
            .imageScale(prominence == .increased ? .large : .medium)
            .animation(.default, value: isExpanded)
    }
}
