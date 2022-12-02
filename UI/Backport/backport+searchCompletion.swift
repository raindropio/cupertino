import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func searchCompletion(_ completion: String) -> some View {
        if #available(iOS 16, *) {
            content.searchCompletion(completion)
        } else {
            content.modifier(CompleteText(completion: completion))
        }
    }
    
    @ViewBuilder func searchCompletion<T: Identifiable>(_ token: T) -> some View {
        if #available(iOS 16, *) {
            content.searchCompletion(token)
        } else {
            content.modifier(CompleteToken(token: token))
        }
    }
}

extension Backport {
    fileprivate struct CompleteText: ViewModifier {
        @EnvironmentObject private var service: BackportSearchSuggestionsService
        
        var completion: String
        
        func body(content: Content) -> some View {
            Button {
                service.complete(completion)
            } label: {
                content
            }
        }
    }
}

extension Backport {
    fileprivate struct CompleteToken<T: Identifiable>: ViewModifier {
        @EnvironmentObject private var service: BackportSearchSuggestionsService
        
        var token: T
        
        func body(content: Content) -> some View {
            Button {
                service.complete(token)
            } label: {
                content
            }
        }
    }
}
