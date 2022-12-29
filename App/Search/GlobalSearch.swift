import SwiftUI
import API
import Common
import Backport

extension View {
    func globalSearch(find: Binding<FindBy>) -> some View {
        modifier(GlobalSearch(find: find))
    }
}

struct GlobalSearch: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var temp: String = ""
    
    @Binding var find: FindBy
    
    func body(content: Content) -> some View {
        content
            //debounce text
            .task(id: find.text, priority: .background) { temp = find.text }
            .task(id: temp, priority: .background, debounce: 0.5) { find.text = temp }
            //search bar
            .backport.searchable(
                text: $temp,
                tokens: $find.filters,
                placement: searchPlacement,
                token: FilterRow.init
            ) {
                Suggestions(find: find)
            }
            .searchBar(withButton: true, scopeBarActivation: .onSearchActivation)
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
