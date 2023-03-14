import SwiftUI

public extension Backport where Wrapped: View {
    func defaultFocus<V>(_ binding: FocusState<V>.Binding, _ value: V, priority: DefaultFocusEvaluationPriority = .automatic) -> some View {
        content
            #if canImport(AppKit)
            .defaultFocus(binding, value, priority: priority)
            #else
            .onAppear { binding.wrappedValue = value }
            .environment(\.backportDefaultFocus, value)
            #endif
    }
}

#if canImport(UIKit)
public extension EnvironmentValues {
    var backportDefaultFocus: AnyHashable? {
        get {
            self[BackportDefaultFocusKey.self]
        } set {
            if self[BackportDefaultFocusKey.self] != newValue {
                self[BackportDefaultFocusKey.self] = newValue
            }
        }
    }
    
    private struct BackportDefaultFocusKey: EnvironmentKey {
        static let defaultValue: AnyHashable? = nil
    }
}
#endif
