import SwiftUI
import API
import UI
import Common

extension SidebarScreen {
    struct Toolbar: ViewModifier {
        @EnvironmentObject private var app: AppRouter
        @EnvironmentObject private var settings: SettingsRouter
        @Environment(\.editMode) private var editMode

        func body(content: Content) -> some View {
            content
                .meNavigationTitle()
                .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        if editMode?.wrappedValue != .active {
                            Button {
                                app.spotlight = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            settings.open()
                        } label: {
                            MeLabel()
                                .labelStyle(.iconOnly)
                        }
                    }
                }
        }
    }
}
