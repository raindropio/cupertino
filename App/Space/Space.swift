import SwiftUI
import Features
import API
import UI

struct Space: View {
    var find: FindBy
    
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
    }
}
