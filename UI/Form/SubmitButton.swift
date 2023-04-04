import SwiftUI

public struct SubmitButton<Label>: View where Label: View {
    @Environment(\.onSubmitAction) private var onSubmitAction
    @Environment(\.submitting) private var submitting
    @ViewBuilder private var label: () -> Label
    
    public init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }

    public var body: some View {
        Button(action: onSubmitAction) {
            HStack(spacing: 6) {
                if submitting {
                    ProgressView()
                }
                
                label()
            }
                .frame(minHeight: 32)
                .frame(maxWidth: .infinity)
        }
            .buttonStyle(.borderedProminent)
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
