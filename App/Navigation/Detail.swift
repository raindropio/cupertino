import SwiftUI
import API

struct Detail: View {
    var section: SidebarSelection
    @Binding var path: NavigationPath
    
    func browse(_ selection: SidebarSelection) -> some View {
        Group { switch selection {
            case .collection(let collection):
                CollectionView(collection: collection)
                
            case .filter(let filter):
                FilterView(filter: filter)
                
            case .tag(let tag):
                TagView(tag: tag)
        } }
            .contextAction(forSelectionType: Raindrop.self) {
                if $0.count == 1, let raindrop = $0.first {
                    path.append(raindrop)
                }
            }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            browse(section)
                .navigationDestination(for: Collection.self) {
                    browse(.collection($0))
                }
                .navigationDestination(for: Filter.self) {
                    browse(.filter($0))
                }
                .navigationDestination(for: Tag.self) {
                    browse(.tag($0))
                }
                .navigationDestination(for: Raindrop.self) {
                    RaindropView(raindrop: $0)
                }
        }
    }
}
