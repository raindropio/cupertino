import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func searchCompletion(_ completion: String) -> some View {
        if #available(iOS 16, *) {
            content.searchCompletion(completion)
        } else {
            content.modifier(CompleteText(completion: completion))
        }
    }
    
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
    @EnvironmentObject private var complete: CompletionService
    var token: T
    
    func body(content: Content) -> some View {
        Button {
            complete(token)
        } label: {
            content
        }
    }
}

fileprivate struct CompleteText: ViewModifier {
    @EnvironmentObject private var complete: CompletionService
    var completion: String
    
    func body(content: Content) -> some View {
        Button {
            complete(completion)
        } label: {
            content
        }
    }
}
