import SwiftUI

public struct SubmitButton<Label>: View where Label: View {
    @Environment(\.onSubmitAction) private var onSubmitAction
    @ViewBuilder private var label: () -> Label
    
    public init(label: @escaping () -> Label) {
        self.label = label
    }

    public var body: some View {
        Button(action: onSubmitAction) {
            label()
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
