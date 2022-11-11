import SwiftUI
import API
import UI

struct SidebarScreen: View {
    @EnvironmentObject private var app: AppRouter
    @EnvironmentObject private var settings: SettingsRouter

    var body: some View {
        OptionalGlobalSearch {
            CollectionsList(
                selection: $app.sidebarSelection,
                searchable: false
            ) {
                NavigationLink {
                    Text("Hi").navigationTitle("Bla")
                } label: {
                    Label("Filters & Tags", systemImage: "square.grid.2x2")
                }
            }
        }
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

extension SidebarScreen {
    fileprivate struct OptionalGlobalSearch<C: View>: View {
        @State private var find = FindBy()
        var content: () -> C
        
        var body: some View {
            if isPhone {
                Group {
                    if find.isSearching {
                        RaindropsList(find: find)
                    } else {
                        content()
                    }
                }
                    .globalSearch(find: $find)
            } else {
                content()
            }
        }
    }
}
