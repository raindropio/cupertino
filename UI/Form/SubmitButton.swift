import SwiftUI
import Backport

public struct SubmitButton<Label>: View where Label: View {
    @Environment(\.onSubmitAction) private var onSubmitAction
    @Environment(\.submitting) private var submitting
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.defaultMinListRowHeight) private var defaultMinListRowHeight

    @ViewBuilder private var label: () -> Label
    
    public init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }

    public var body: some View {
        Button(action: onSubmitAction) {
            ZStack {
                ProgressView()
                    .opacity(submitting ? 1 : 0)
                
                label()
                    .opacity(submitting ? 0 : 1)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
            .buttonStyle(Backport.glassProminent)
            .fontWeight(.semibold)
            .clearSection()
    }
}

extension SubmitButton where Label == Text {
    public init<S>(_ title: S) where S : StringProtocol {
        self.label = {
            Text(title)
        }
    }
}
