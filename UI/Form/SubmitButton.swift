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
            ZStack {
                ProgressView()
                    .opacity(submitting ? 1 : 0)
                
                label()
                    .opacity(submitting ? 0 : 1)
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
