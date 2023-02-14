import SwiftUI
import Combine

//MARK: - Buttons
public func SearchCompletionButton<L: View>(_ completion: String, label: @escaping () -> L) -> some View {
    TextButton(completion: completion, label: label)
}

public func SearchCompletionButton<T: Identifiable, L: View>(_ token: T, replace: Bool = true, label: @escaping () -> L) -> some View {
    TokenButton(token: token, replace: replace, label: label)
}

fileprivate struct TextButton<L: View>: View {
    @EnvironmentObject private var service: TextService
    
    var completion: String
    var label: () -> L
    
    var body: some View {
        Button(action: {
            service.subject.send(completion)
        }, label: label)
    }
}

fileprivate struct TokenButton<T: Identifiable, L: View>: View {
    @EnvironmentObject private var service: TokensService<T>
    
    var token: T
    var replace: Bool
    var label: () -> L
    
    var body: some View {
        Button(action: {
            service.subject.send(.init(value: token, replace: replace))
        }, label: label)
    }
}

//MARK: - searchCompletionButtons modifier
public extension View {
    func searchCompletionButtons<T: RandomAccessCollection & RangeReplaceableCollection>(text: Binding<String>, tokens: Binding<T>) -> some View where T.Element: Identifiable {
        modifier(SC(text: text, tokens: tokens))
    }
}

fileprivate struct SC<T: RandomAccessCollection & RangeReplaceableCollection>: ViewModifier where T.Element: Identifiable {
    @StateObject private var textService = TextService()
    @StateObject private var tokensService = TokensService<T.Element>()

    @Binding var text: String
    @Binding var tokens: T
    
    func body(content: Content) -> some View {
        content
            .onReceive(textService.subject) {
                text = $0
            }
            .onReceive(tokensService.subject) { token in
                let exists = tokens.contains {
                    $0.id == token.value.id
                }
                if !exists {
                    if token.replace {
                        text = ""
                    }
                    tokens.append(token.value)
                }
            }
            .environmentObject(tokensService)
            .environmentObject(textService)
    }
}

fileprivate class TokensService<T: Identifiable>: ObservableObject {
    let subject: PassthroughSubject<Token, Never> = PassthroughSubject()
    
    struct Token {
        var value: T
        var replace: Bool
    }
}

fileprivate class TextService: ObservableObject {
    let subject: PassthroughSubject<String, Never> = PassthroughSubject()
}
