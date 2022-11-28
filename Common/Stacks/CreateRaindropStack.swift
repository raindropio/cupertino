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
    }
}

extension CreateRaindropStack {
    struct New: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss
        
        @Binding var raindrop: Raindrop
        
        var body: some View {
            NavigationStack {
                RaindropForm(raindrop: $raindrop)
                    .navigationTitle("New bookmark")
                    .navigationBarTitleDisplayMode(.inline)
                    .safeAreaInset(edge: .bottom) {
                        ActionButton {
                            try await dispatch(RaindropsAction.create(raindrop))
                            dismiss()
                        } label: {
                            Text("Save").frame(maxWidth: .infinity)
                        }
                            .buttonStyle(.borderedProminent)
                            .fontWeight(.semibold)
                            .scenePadding()
                            .background(.bar)
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", action: dismiss.callAsFunction)
                        }
                    }
            }
        }
    }
}
