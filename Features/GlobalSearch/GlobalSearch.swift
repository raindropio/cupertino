import SwiftUI
import API

struct GlobalSearch: ViewModifier {
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
                token: FilterItem.init
            )
            #if canImport(UIKit)
            .searchBar(withButton: true, scopeBarActivation: .onSearchActivation)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .keyboardType(.webSearch)
            #endif
            .modifier(Scopes(find: $find))
            .modifier(Suggestions(find: $find))
    }
    
    #if os(iOS)
    var searchPlacement: SearchFieldPlacement {
        find.isSearching && sizeClass == .compact ? .navigationBarDrawer(displayMode: .always) : .automatic
    }
    #else
    let searchPlacement = SearchFieldPlacement.automatic
    #endif
}

extension View {
    func globalSearch(find: Binding<FindBy>) -> some View {
        modifier(GlobalSearch(find: find))
    }
}
