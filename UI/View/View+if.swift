import SwiftUI

public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies the given transform if/else the given condition.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    ///   - else: The transform to apply to the source `View` otherwise.
    /// - Returns: Either the modified `View` depending on condition.
    @ViewBuilder func `if`<Positive: View, Negative: View>(_ condition: Bool, transform: (Self) -> Positive, else: (Self) -> Negative) -> some View {
        if condition {
            transform(self)
        } else {
            `else`(self)
        }
    }
}
