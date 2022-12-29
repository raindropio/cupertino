import SwiftUI
import API
import UI
import Common

extension SidebarScreen {
    struct Me: ViewModifier {
        @EnvironmentObject private var settings: SettingsRouter

        func body(content: Content) -> some View {
            content
                .meNavigationTitle()
                .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
                .toolbar {
                    ToolbarItem(placement: isPhone ? .cancellationAction : .primaryAction) {
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
