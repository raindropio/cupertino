import SwiftUI
import API
import Combine

extension TagEvents {
    struct Merge: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var newName: String
        var tags: Set<String>
        
        init(_ tags: Set<String>) {
            self._newName = .init(initialValue: tags.first ?? "")
            self.tags = tags
        }
        
        func submit() {
            guard !newName.isEmpty else { return }
            dispatch.sync(FiltersAction.update(
                .init(tags.map { .init(.tag($0)) }),
                newName: newName
            ))
        }
        
        var body: some View {
            TextField("New name", text: $newName)
                .onSubmit(submit)
            Button("Update", action: submit)
            Button("Cancel", role: .cancel) {}
        }
    }
}
