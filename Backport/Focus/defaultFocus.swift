import SwiftUI

public extension Backport where Wrapped: View {
    func defaultFocus<V>(_ binding: FocusState<V>.Binding, _ value: V, priority: DefaultFocusEvaluationPriority = .automatic) -> some View {
        content
            #if os(macOS)
            .defaultFocus(binding, value, priority: priority)
            #else
            .onAppear {
                binding.wrappedValue = value
            }
            #endif
    }
}
