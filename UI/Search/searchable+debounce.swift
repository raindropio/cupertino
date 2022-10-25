import SwiftUI

public extension View {
    func searchable<C: RandomAccessCollection & RangeReplaceableCollection & Equatable, T: View>(
        text: Binding<String>,
        debounce: UInt64 = 0,
        tokens: Binding<C>,
        placement: SearchFieldPlacement = .automatic,
        prompt: Text? = nil,
        token: @escaping (C.Element) -> T
    ) -> some View where C.Element : Identifiable {
        modifier(SearchableDebounceModifier(text: text, debounce: debounce, tokens: tokens, placement: placement, token: token))
    }
}

fileprivate struct SearchableDebounceModifier<C: RandomAccessCollection & RangeReplaceableCollection & Equatable, T: View>: ViewModifier where C.Element : Identifiable {
    @State private var temp = ""
    
    @Binding var text: String
    var debounce: UInt64 = 0
    @Binding var tokens: C
    var placement: SearchFieldPlacement
    var prompt: Text?
    var token: (C.Element) -> T
    
    func body(content: Content) -> some View {
        content
            .searchable(
                text: $temp,
                tokens: $tokens,
                placement: placement,
                prompt: prompt,
                token: token
            )
            .task(id: temp, priority: .utility) {
                do {
                    if !temp.isEmpty, temp != text {
                        try await Task.sleep(nanoseconds: 1_000_000 * debounce)
                    }
                    text = temp
                } catch {}
            }
            .task(id: text) {
                if temp != text {
                    temp = text
                }
            }
    }
}
