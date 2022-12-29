import SwiftUI
import API
import UI

extension SidebarScreen {
    struct Phone: ViewModifier {
        @Binding var search: String

        func body(content: Content) -> some View {
            if isPhone {
                content
                    .fab()
                    .searchable(text: $search)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.webSearch)
            } else {
                content
            }
        }
    }
}
