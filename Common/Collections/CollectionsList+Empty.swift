import SwiftUI
import API

extension CollectionsList {
    struct Empty: View {
        @EnvironmentObject private var c: CollectionsStore
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var actions: CollectionActionsStore

        var body: some View {
            Memorized(
                isEmpty: c.state.isEmpty,
                status: c.state.status
            )
        }
    }
}

extension CollectionsList.Empty {
    struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var action: CollectionActionsStore
        
        var isEmpty: Bool
        var status: CollectionsState.Status

        var body: some View {
            if isEmpty {
                ZStack {
                    switch status {
                    case .loading:
                        ProgressView()
                        
                    case .error:
                        VStack {
                            Text("Error")
                            Button("Try again") {
                                dispatch.sync(CollectionsAction.load)
                            }
                        }
                        
                    case .idle:
                        VStack {
                            Text("Empty")
                            
                            Button("Create collection") {
                                action(.create())
                            }
                        }
                    }
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.background)
                    .transition(.opacity)
            }
        }
    }
}
