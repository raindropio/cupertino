import SwiftUI
import API
import Combine

extension _TagSheetsModifier {
    struct Rename: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var newName: String
        var tag: String
        
        init(_ tag: String) {
            self._newName = .init(initialValue: tag)
            self.tag = tag
        }
        
        func submit() {
            guard newName != tag else { return }
            dispatch.sync(FiltersAction.update([tag], newName: newName))
        }
        
        var body: some View {
            TextField("New name", text: $newName)
                .onSubmit(submit)
            Button("Update", action: submit)
            Button("Cancel", role: .cancel) {}
        }
    }
}
