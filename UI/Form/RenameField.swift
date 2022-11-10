import SwiftUI

public struct RenameField: View {
    var title: String
    @State var text: String
    var focused: FocusState<Bool>.Binding
    var onSubmit: (String) -> Void
    
    public init(
        _ title: String = "",
        text: String,
        focused: FocusState<Bool>.Binding,
        onSubmit: @escaping (String) -> Void
    ) {
        self.title = title
        self.text = text
        self.focused = focused
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        TextField(title, text: $text)
            .focused(focused)
            .onSubmit {
                onSubmit(text)
            }
            .onChange(of: focused.wrappedValue) {
                if !$0 {
                    onSubmit(text)
                }
            }
    }
}
