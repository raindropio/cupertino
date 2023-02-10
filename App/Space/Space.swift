import SwiftUI
import Features
import API
import UI

struct Space: View {
    @EnvironmentObject private var app: AppRouter
    var find: FindBy
    
    var body: some View {
        Search(find) { refine, isSearching in
            Folder(find: refine) {                
                if isSearching {
                    SearchSuggestions(refine)
                } else {
                    Nesteds(find: refine)
                }
            }
        }
            .raindropsEvent {
                switch $0 {
                case .open(let id), .preview(let id):
                    app.browse(id)
                    break
                    
                case .cache(let id):
                    app.browse(id, mode: .cache)
                    break
                    
                case .collection(let id):
                    app.space = .init(id)
                    
                case .filter(let filter):
                    app.path.append(find + .init(filters: [filter]))
                }
            }
    }
}
