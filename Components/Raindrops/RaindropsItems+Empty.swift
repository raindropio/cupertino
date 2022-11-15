import SwiftUI
import API
import UI

extension RaindropsItems {
    struct Empty: View {
        @EnvironmentObject private var r: RaindropsStore
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        
        var body: some View {
            Memorized(find: find, status: r.state.status(find))
                .animation(.default, value: r.state.status(find))
        }
    }
}

extension RaindropsItems.Empty {
    struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var status: RaindropsState.Segment.Status
        
        var body: some View {
            Group {
                switch status {
                case .idle:
                    GroupBox {
                        if find.isSearching {
                            Text("Nothing found")
                                .frame(maxWidth: .infinity)

                        } else {
                            Text("Empty")
                                .frame(maxWidth: .infinity)
                            
                            Button("Create bookmark") {
                                
                            }
                        }
                    }
                        .clearSection()
                        .scenePadding()
                
                case .loading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                    
                case .error:
                    GroupBox {
                        Text("Error")
                            .frame(maxWidth: .infinity)

                        Button("Try again") {
                            dispatch.sync(RaindropsAction.load(find))
                        }
                    }
                        .clearSection()
                        .scenePadding()
                    
                case .notFound:
                    GroupBox {
                        Text("Not found")
                            .frame(maxWidth: .infinity)
                    }
                        .clearSection()
                        .scenePadding()
                }
            }
                .transition(.opacity)
        }
    }
}
