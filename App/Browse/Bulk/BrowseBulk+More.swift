import SwiftUI
import API
import UI

extension BrowseBulk {
    struct More: View {
        @EnvironmentObject private var dispatch: Dispatcher

        //props
        var pick: RaindropsPick
        var action: ( @escaping () async throws -> Void ) -> Void
    
        var body: some View {
            Menu {
                Group {
                    //remove tags
                    Menu {
                        Button("Confirm", role: .destructive) {
                            action {
                                try await dispatch(RaindropsAction.updateMany(pick, .removeTags))
                            }
                        }
                    } label: {
                        Label("Remove tags", systemImage: "tag.slash")
                    }
                }
                    .labelStyle(.titleAndIcon)
            } label: {
                Label("More", systemImage: "ellipsis")
            }
        }
    }
}
