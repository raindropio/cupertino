import SwiftUI
import API
import UI

public func CollectionStack<C: View>(_ collection: UserCollection, content: @escaping (Binding<UserCollection>) -> C) -> some View {
    New(draft: collection, content: content)
}

public func CollectionStack<C: View>(_ collection: Binding<UserCollection>, content: @escaping (Binding<UserCollection>) -> C) -> some View {
    Stack(draft: collection, content: content)
}

//MARK: - New
fileprivate struct New<C: View>: View {
    @EnvironmentObject private var r: CollectionsStore
    
    @State var draft: UserCollection
    var content: (Binding<UserCollection>) -> C
    
    var body: some View {
        Stack(draft: $draft, content: content)
    }
}

//MARK: - Common
fileprivate struct Stack<C: View>: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    @Binding var draft: UserCollection
    var content: (Binding<UserCollection>) -> C
    
    //auto-save for existing bookmarks
    private func saveOnClose() {
        guard !draft.isNew else { return }
        dispatch.sync(CollectionsAction.update(draft))
    }
    
    var body: some View {
        NavigationStack {
            content($draft)
                .toolbar {
                    ToolbarItem(placement: draft.isNew ? .cancellationAction : .confirmationAction) {
                        Button(draft.isNew ? "Cancel" : "Done", action: dismiss.callAsFunction)
                    }
                }
        }
            .onDisappear(perform: saveOnClose)
    }
}
