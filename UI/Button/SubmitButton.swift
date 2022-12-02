import SwiftUI

public struct SubmitButton<Label>: View where Label: View {
    @Environment(\.onSubmitAction) private var onSubmitAction
    @Environment(\.submitting) private var submitting
    @ViewBuilder private var label: () -> Label
    
    public init(label: @escaping () -> Label) {
        self.label = label
    }

    public var body: some View {        
        Button(action: onSubmitAction) {
            ZStack {
                label()
                    .opacity(submitting ? 0 : 1)
                
                if submitting {
                    ProgressView().progressViewStyle(.circular)
                }
            }
                .frame(minHeight: 32)
                .frame(maxWidth: .infinity)
        }
            .buttonStyle(.borderedProminent)
            .font(.headline)
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
