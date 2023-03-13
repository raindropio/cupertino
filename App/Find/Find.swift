import SwiftUI
import Features
import API
import UI

struct Find: View {
    var find: FindBy = .init()
    
    var body: some View {
        Search(find) { refine, isSearching in
            Folder(find: refine) {                
                if isSearching {
                    SearchSuggestions(refine)
                        .controlSize(.small)
                } else {
                    Nesteds(find: refine)
                }
            }
        }
            .id(find)
            .dropProvider()
    }
}
