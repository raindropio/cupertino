import SwiftUI

public extension View {
    func safeAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        modifier(SafeAnimation(animation: animation, value: value))
    }
}

fileprivate struct SafeAnimation<V: Equatable>: ViewModifier {
    @Environment(\.isPresented) private var isPresented
    @State private var enabled = false
    
    var animation: Animation?
    var value: V
    
    func body(content: Content) -> some View {
        content
            .animation(animation, value: value)
            .transaction { transaction in
                if !enabled || !isPresented {
                    transaction.animation = nil
                }
            }
            .task(id: isPresented) {
                if isPresented {
                    try? await Task.sleep(for: .seconds(1))
                }
                enabled = isPresented
            }
    }
}
