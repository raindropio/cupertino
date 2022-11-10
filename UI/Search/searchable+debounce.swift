import SwiftUI

public extension View {
    func searchable(
        text: Binding<String>,
        debounce: Double,
        placement: SearchFieldPlacement = .automatic
    ) -> some View {
        modifier(SearchableDebounceModifier(text: text, debounce: debounce, placement: placement))
    }
    
    func searchable<C: RandomAccessCollection & RangeReplaceableCollection & Equatable, T: View>(
        text: Binding<String>,
        debounce: Double,
        tokens: Binding<C>,
        placement: SearchFieldPlacement = .automatic,
        prompt: Text? = nil,
        token: @escaping (C.Element) -> T
    ) -> some View where C.Element : Identifiable {
        modifier(SearchableTokensDebounceModifier(text: text, debounce: debounce, tokens: tokens, placement: placement, prompt: prompt, token: token))
    }
}

fileprivate struct SearchableDebounceModifier: ViewModifier {
    @Binding var text: String
    var debounce: Double = 0
    var placement: SearchFieldPlacement
    
    @State private var temp = ""
    
    func body(content: Content) -> some View {
        content
            .searchable(
                text: $temp,
                placement: placement
            )
            .modifier(DebounceSearchText(text: $text, temp: $temp, debounce: debounce))
    }
}

fileprivate struct SearchableTokensDebounceModifier<C: RandomAccessCollection & RangeReplaceableCollection & Equatable, T: View>: ViewModifier where C.Element : Identifiable {
    @State private var temp = ""
    
    @Binding var text: String
    var debounce: Double = 0
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
            .modifier(DebounceSearchText(text: $text, temp: $temp, debounce: debounce))
    }
}

fileprivate struct DebounceSearchText: ViewModifier {
    @Binding var text: String
    @Binding var temp: String
    var debounce: Double = 0

    func body(content: Content) -> some View {
        content
            .onSubmit(of: .search) {
                text = temp
            }
            .task(id: text) {
                if temp != text {
                    temp = text
                }
            }
            //auto submit
            .task(id: temp, priority: .background) {
                do {
                    //wait
                    if !temp.isEmpty, temp != text {
                        try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * debounce))
                    }
                    //do not submit if there space in the end
                    if !temp.hasSuffix(" ") {
                        text = temp
                    }
                } catch {}
            }
            
    }
}


