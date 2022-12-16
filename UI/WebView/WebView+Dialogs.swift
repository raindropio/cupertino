import SwiftUI

extension WebView {
    struct Dialogs: ViewModifier {
        @ObservedObject var page: WebPage
        @State private var promptText = ""

        func body(content: Content) -> some View {
            content
            
            //alert
            .alert(
                "",
                isPresented: $page.alert.bool(),
                presenting: page.alert
            ) { alert in
                Button("OK", role: .cancel, action: alert.callback)
            } message: { alert in
                Text(alert.message)
            }
            
            //confirm
            .confirmationDialog(
                "",
                isPresented: $page.confirm.bool(),
                presenting: page.confirm
            ) { confirm in
                Button("Confirm") { confirm.callback(true) }
                Button("Cancel", role: .cancel) { confirm.callback(false) }
            } message: { confirm in
                Text(confirm.message)
            }
            
            //prompt
            .alert(
                "",
                isPresented: $page.prompt.bool(),
                presenting: page.prompt
            ) { prompt in
                TextField(prompt.message, text: $promptText)
                    .onAppear { promptText = prompt.defaultValue ?? "" }
                Button("OK") { prompt.callback(promptText) }
                Button("Cancel", role: .cancel) { prompt.callback(nil) }
            } message: { prompt in
                Text(prompt.message)
            }
        }
    }
}

