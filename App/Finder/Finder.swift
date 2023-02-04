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
                    break
                    
                case .cache(let id):
                    break
                    
                case .find(let find):
                    app.find = find
                }
            }
            .scopeEditMode()
    }
}
