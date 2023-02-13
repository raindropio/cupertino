import SwiftUI
import API

extension _CollectionSheetsModifier {
    struct GroupEdit: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var newName: String
        var group: CGroup
        
        init(_ group: CGroup) {
            self._newName = .init(initialValue: group.title)
            self.group = group
        }
        
        func submit() {
            guard newName != group.title else { return }
            var group = group
            group.title = newName
            dispatch.sync(CollectionsAction.renameGroup(group))
        }
        
        var body: some View {
            TextField("New name", text: $newName)
                .onSubmit(submit)
            Button("Update", action: submit)
            Button("Cancel", role: .cancel) {}
        }
    }
}

extension _CollectionSheetsModifier {
    struct GroupDelete: View {
        @EnvironmentObject private var dispatch: Dispatcher
        var group: CGroup

        var body: some View {
            Button("Delete group", role: .destructive) {
                dispatch.sync(CollectionsAction.deleteGroup(group))
            }
        }
    }
}
