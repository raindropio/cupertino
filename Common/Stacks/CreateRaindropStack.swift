import SwiftUI
import API
import UI

public struct CreateRaindropStack {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var raindrop: Raindrop
    @State private var loading = false
    
    public init(_ link: URL) {
        self._raindrop = State(initialValue: .new(link: link))
    }
    
    public init(_ raindrop: Raindrop) {
        self._raindrop = State(initialValue: raindrop)
    }
}

extension CreateRaindropStack: View {
    public var body: some View {
        Group {
            if raindrop.id == 0 {
                New(raindrop: $raindrop)
                    .disabled(loading)
                    .task {
                        loading = true
                        try? await dispatch(RaindropsAction.find($raindrop))
                        loading = false
                    }
            } else {
                EditRaindropStack(raindrop)
            }
        }
            .transition(.opacity)
            .animation(.default, value: loading)
            .animation(.default, value: raindrop.id)
    }
}
