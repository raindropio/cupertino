import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func listSelectionFix<S: Hashable>(_ selection: Binding<S?>) -> some View {
        if #available(iOS 16, *) {
            content
        } else {
            content
                .labelStyle(ListSelectionFixLabel(selection: selection))
        }
    }
}

fileprivate struct ListSelectionFixLabel<S: Hashable>: LabelStyle {
    @Binding var selection: S?
    @Environment(\.backportTag) private var backportTag
    
    var tag: S? {
        backportTag as? S
    }
    
    var background: Optional<Color> {
        selection == tag ? .tertiaryLabel : nil
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            selection = tag
        } label: {
            Label {
                configuration.title
                    .foregroundColor(.primary)
            } icon: {
                configuration.icon
            }
            .listRowBackground(Color.red)
        }
    }
}
