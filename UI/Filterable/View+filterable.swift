import SwiftUI

public extension View {
    func filterable(
        text: Binding<String>,
        icon: String = "magnifyingglass",
        prompt: String = "Search",
        autoFocus: Bool = true
    ) -> some View {
        modifier(FilterableModifier(text: text, icon: icon, prompt: prompt, autoFocus: autoFocus))
    }
    
    func filterable<H: View>(
        text: Binding<String>,
        icon: String = "magnifyingglass",
        prompt: String = "Search",
        autoFocus: Bool = true,
        @ViewBuilder header: @escaping () -> H
    ) -> some View {
        modifier(FilterableModifier(text: text, icon: icon, prompt: prompt, autoFocus: autoFocus, header: header))
    }
}

struct FilterableModifier<H: View>: ViewModifier {
    @FocusState private var focused: Bool
    
    @Binding var text: String
    var icon: String
    var prompt: String
    var autoFocus: Bool
    var header: (() -> H)?
    
    var field: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            
            TextField(prompt, text: $text)
                .focused($focused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.webSearch)
                .submitLabel(.search)
        }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.primary.opacity(0.05))
            }
    }
    
    @ViewBuilder
    var cancel: some View {
        if focused {
            Button("Cancel") {
                text = ""
                focused = false
            }
                .scenePadding(.leading)
                .transition(
                    .move(edge: .trailing)
                    .combined(with: .opacity)
                )
        }
    }
    
    func body(content: Content) -> some View {
        content.safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                header?()
                
                HStack(spacing: 0) {
                    field
                    cancel
                }
                    .animation(.default, value: focused)
                    .scenePadding()
            }
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                ._onButtonGesture(pressing: nil) {
                    focused = true
                }
                .onSubmit {
                    focused = true
                }
        }
            .interactiveDismissDisabled(focused)
            .onAppear {
                if autoFocus {
                    focused = true
                }
            }
    }
}

extension FilterableModifier where H == EmptyView {
    init(
        text: Binding<String>,
        icon: String,
        prompt: String,
        autoFocus: Bool
    ) {
        self._text = text
        self.icon = icon
        self.prompt = prompt
        self.autoFocus = autoFocus
    }
}
