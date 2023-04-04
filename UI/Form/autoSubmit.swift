import SwiftUI

public extension View {
    func autoSubmit(_ condition: Bool) -> some View {
        modifier(AS(condition: condition))
    }
}

fileprivate struct AS: ViewModifier {
    @Environment(\.onSubmitAction) private var onSubmitAction
    var condition: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if condition {
                    onSubmitAction()
                }
            }
            .onChange(of: condition) {
                if $0 {
                    onSubmitAction()
                }
            }
    }
}
