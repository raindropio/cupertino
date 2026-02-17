import SwiftUI
import API
import UI
import Features

extension SidebarScreen {
    struct Search: ViewModifier {
        @Environment(\.containerHorizontalSizeClass) private var sizeClass

        @Binding var selection: FindBy?
        @Binding var search: String

        func body(content: Content) -> some View {
            content
                #if canImport(UIKit)
                .if(sizeClass == .compact) {
                    $0
                        .modifier(AutoDismiss(selection: $selection))
                        .searchable(text: $search)
                        .onSubmit(of: .search) {
                            selection = .init(search)
                        }
                }
                #endif
        }
    }
}

fileprivate struct AutoDismiss: ViewModifier {
    @Environment(\.dismissSearch) private var dismissSearch
    @Binding var selection: FindBy?
    
    func body(content: Content) -> some View {
        content.onChange(of: selection) { old, new in
            if new?.collectionId == 0, new?.text.isEmpty == false {
                //make sure to run async, otherwise crash
                Task {
                    dismissSearch()
                }
            }
        }
    }
}
