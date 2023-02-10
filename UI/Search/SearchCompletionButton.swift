import SwiftUI

public struct SearchCompletionButton<T: Identifiable, L: View>: View {
    var token: T
    var label: () -> L
    
    public init(_ token: T, label: @escaping () -> L) {
        self.token = token
        self.label = label
    }
    
    public var body: some View {
        Button(action: {
            
        }, label: label)
    }
}
