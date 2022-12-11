import SwiftUI
import API
import UI
import Common

struct SidebarScreen {
    @EnvironmentObject private var app: AppRouter
    @EnvironmentObject private var settings: SettingsRouter
    
    @State private var selection: Int?
}

extension SidebarScreen {
    @Sendable func pathChange() async {
        switch app.path.first {
        case .browse(let find): selection = find.collectionId
        case .filters: selection = -2
        default: selection = nil
        }
    }
    
    func sidebarChange(_ selection: Int?) {
        if let collectionId = selection {
            if collectionId == -2 {
                app.path = [.filters]
            } else {
                app.path = [.browse(.init(collectionId))]
            }
        } else {
            app.path = []
        }
    }
}

extension SidebarScreen: View {
    var body: some View {
        CollectionsList(
            selection: $selection,
            searchable: false
        ) {
            Label {
                Text("Filters & Tags")
            } icon: {
                Image(systemName: "circle.grid.2x2")
                    .imageScale(.large)
            }
                .listItemTint(.indigo)
                .backport.tag(-2)
        }
            .task(id: app.path, pathChange)
            .onChange(of: selection, perform: sidebarChange)
            .modifier(Phone())
            .navigationTitle("Collections")
            .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        settings.open()
                    }, label: MeLabel.init)
                }
            }
    }
}
