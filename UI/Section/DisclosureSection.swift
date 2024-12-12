import SwiftUI

//MARK: - Init
public func DisclosureSection<L: StringProtocol, C: View>(
    _ label: L,
    expandable: Bool = true,
    isExpanded: Binding<Bool>,
    content: @escaping () -> C
) -> some View {
    _DisclosureSection(
        isExpanded: isExpanded.wrappedValue,
        content: content
    ) {
        _SectionHeader(expandable: expandable, isExpanded: isExpanded, label: Text(label)) {}
    }
}

public func DisclosureSection<L: StringProtocol, C: View, A: View>(
    _ label: L,
    expandable: Bool = true,
    isExpanded: Binding<Bool>,
    content: @escaping () -> C,
    actions: @escaping () -> A
) -> some View {
    _DisclosureSection(
        isExpanded: isExpanded.wrappedValue,
        content: content
    ) {
        _SectionHeader(expandable: expandable, isExpanded: isExpanded, label: Text(label), actions: actions)
    }
}

public func DisclosureSection<L: StringProtocol, C: View, A: View>(
    _ label: L,
    expandable: Bool = true,
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
            expandable: expandable,
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

#if os(macOS)
fileprivate struct _SectionHeader<L: View, A: View>: View {
    @State private var hover = false
    
    var expandable: Bool
    @Binding var isExpanded: Bool
    var label: L
    @ViewBuilder var actions: () -> A
    
    var body: some View {
        HStack(spacing: 0) {
            label
            
            Spacer()
            
            Group {
                if isExpanded {
                    actions()
                        .imageScale(.large)
                }
                
                Button { isExpanded.toggle() } label: {
                    Image(systemName: "chevron.right")
                        .imageScale(.medium)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
                .opacity(hover ? 1 : 0)
        }
            .padding(.trailing, 8)
            .lineLimit(1)
            .onHover { hover = $0 }
            .buttonStyle(_SectionButtonStyle())
    }
}

fileprivate struct _SectionButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.iconOnly)
            .frame(width: 24, height: 24)
            .fixedSize()
            .contentShape(Rectangle())
    }
}
#else
fileprivate struct _SectionHeader<L: View, A: View>: View {
    @Environment(\.headerProminence) private var prominence
    
    var expandable: Bool
    @Binding var isExpanded: Bool
    var label: L
    @ViewBuilder var actions: () -> A
    
    var body: some View {
        HStack(spacing: 10) {
            label
                ._onButtonGesture(pressing: nil) {
                    guard expandable else { return }
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
                .buttonStyle(.plain)
                .foregroundColor(.gray)
                .opacity(expandable ? 1 : 0)
            
            Spacer()
            
            if isExpanded {
                actions()
            }
        }
            .lineLimit(1)
            .imageScale(prominence == .increased ? .large : .medium)
            .safeAnimation(.default, value: isExpanded)
    }
}
#endif
