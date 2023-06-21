import SwiftUI

public struct SubmitButton<Label>: View where Label: View {
    @Environment(\.onSubmitAction) private var onSubmitAction
    @Environment(\.submitting) private var submitting
    @Environment(\.isEnabled) private var isEnabled
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
                .frame(maxWidth: .infinity)
        }
            .buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
            .listRowBackground(isEnabled ? Color.accentColor : Color.black.opacity(0))
            .listRowInsets(.init())
    }
}

extension SubmitButton where Label == Text {
    public init<S>(_ title: S) where S : StringProtocol {
        self.label = {
            Text(title)
        }
    }
}
