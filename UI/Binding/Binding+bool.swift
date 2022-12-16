import SwiftUI

extension Binding {
    func bool<T>() -> Binding<Bool> where Value == Optional<T> {
        .init {
            self.wrappedValue != nil
        } set: {
            if !$0 {
                self.wrappedValue = nil
            }
        }
    }
}
