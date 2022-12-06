import SwiftUI
import API
import UI

struct BrowseBulk {
    @Environment(\.isSearching) private var isSearching
    @EnvironmentObject private var r: RaindropsStore
            
    var find: FindBy
    @Binding var selection: Set<Raindrop.ID>
}

extension BrowseBulk: ViewModifier {
    func body(content: Content) -> some View {
        content.modifier(Memorized(
            find:           find,
            selection:      $selection,
            isSearching:    isSearching,
            pick:           selection.count == r.state.items(find).count ? .all(find): .some(selection)
        ))
    }
}

extension BrowseBulk { fileprivate struct Memorized: ViewModifier {
    @Environment(\.editMode) private var editMode
    @State private var loading = false
    @State private var error: RestError?
    
    var find: FindBy
    @Binding var selection: Set<Raindrop.ID>
    
    var isSearching: Bool
    var pick: RaindropsPick
    
    private func action(_ work: @escaping () async throws -> Void) {
        Task {
            loading = true
            error = nil
            
            do {
                try await work()
            } catch is RestError {
                self.error = error
            }
            
            loading = false
            editMode?.wrappedValue = .inactive
        }
    }
    
    private var isEditing: Bool {
        editMode?.wrappedValue == .active
    }
    
    private var isFailed: Binding<Bool> {
        .init { error != nil }
        set: { if !$0 { error = nil } }
    }
    
    func body(content: Content) -> some View {        
        content
        .navigationBarBackButtonHidden(isEditing)
        //title
        .overlay {
            if isEditing, !selection.isEmpty {
                Color.clear
                    .navigationTitle(BrowseBulk.title(pick))
            }
        }
        .overlay {
            if isEditing {
                Color.clear.toolbar {
                    //select all
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ToggleAll(find: find, selection: $selection)
                            .labelStyle(.titleOnly)
                    }
                    
                    //done
                    ToolbarItemGroup(placement: isSearching ? .bottomBar : .cancellationAction) {
                        Done()
                        Spacer()
                    }
                    
                    //actions
                    ToolbarItemGroup(placement: .bottomBar) {
                        Group {
                            Move(pick: pick, action: action)
                            Spacer()
                            AddTags(pick: pick, action: action)
                            Spacer()
                            Delete(pick: pick, action: action)
                            Spacer()
                            More(pick: pick, action: action)
                        }
                            .labelStyle(.titleOnly)
                            .disabled(selection.isEmpty)
                    }
                }
            }
        }
        .disabled(loading)
        //on error
        .alert(isPresented: isFailed, error: error) {}
    }
}}
