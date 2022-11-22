import SwiftUI
import API
import UI
import Common

struct SidebarScreen: View {
    @EnvironmentObject private var app: AppRouter
    @EnvironmentObject private var settings: SettingsRouter

    var body: some View {
        OptionalGlobalSearch {
            CollectionsList(
                selection: $app.sidebarSelection,
                searchable: false
            )
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
