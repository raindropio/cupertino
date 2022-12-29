import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func searchCompletion<T: Identifiable & Hashable>(_ token: T) -> some View {
        if #available(iOS 16, *) {
            content.searchCompletion(token)
        } else {
            content.modifier(CompleteToken(token: token))
        }
    }
}

fileprivate struct CompleteToken<T: Identifiable & Hashable>: ViewModifier {
    @EnvironmentObject private var complete: SearchCompletionToken
    var token: T
    
    func body(content: Content) -> some View {
        Button {
            complete(token)
        } label: {
            content
        }
    }
}
