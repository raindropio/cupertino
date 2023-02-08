import SwiftUI
import Features
import API
import UI

struct Finder: View {
    @EnvironmentObject private var app: AppRouter
    @State private var selection: Set<Raindrop.ID> = .init()
    
    var find: FindBy
    
    var body: some View {
        RaindropsContainer(find, selection: $selection) {
            Nesteds(find: find)
            
            if isPhone {
                Status(find: find)
            }
            
            RaindropItems(find)
            LoadMoreRaindropsButton(find)
        }
            .fab(to: find.collectionId)
            .modifier(Title(find: find))
            .modifier(Toolbar(find: find, selection: $selection))
            .raindropsEvent {
                switch $0 {
                case .open(let id), .preview(let id):
                    app.browse(id)
                    break
                    
                case .cache(let id):
                    app.browse(id, mode: .cache)
                    break
                    
                case .collection(let id):
                    app.find = .init(id)
                    
                case .filter(let filter):
                    app.path.append(find + .init(filters: [filter]))
                }
            }
            .scopeEditMode()
    }
}
