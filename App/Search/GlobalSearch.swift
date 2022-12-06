import SwiftUI
import API
import Common

extension View {
    func globalSearch(find: Binding<FindBy>) -> some View {
        modifier(GlobalSearch(find: find))
    }
}

struct GlobalSearch: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var find: FindBy
    
    func body(content: Content) -> some View {
        content
            //search bar
            .searchable(
                text: $find.text,
                debounce: 0.3,
                tokens: $find.filters,
                placement: searchPlacement,
                token: FilterRow.init
            ) {
                Suggestions(find: $find)
            }
            .task(id: find, priority: .background) {
                try? await dispatch(
                    FiltersAction.reload(find),
                    RecentAction.reload(find)
                )
            }
            #if canImport(UIKit)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .keyboardType(.webSearch)
            #endif
            .modifier(Scopes(find: $find))
    }
    
    #if os(iOS)
    var searchPlacement: SearchFieldPlacement {
        find.isSearching && sizeClass == .compact ? .navigationBarDrawer(displayMode: .always) : .automatic
    }
    #else
    let searchPlacement = SearchFieldPlacement.automatic
    #endif
}
