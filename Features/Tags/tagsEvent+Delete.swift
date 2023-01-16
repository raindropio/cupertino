import SwiftUI
import API
import Combine

extension _TagsEventModifier {
    struct Delete: View {
        @EnvironmentObject private var dispatch: Dispatcher
        var tags: Set<String>
        
        func delete() {
            dispatch.sync(FiltersAction.delete(tags))
        }
        
        var body: some View {
            Button("Delete \(tags.count) tags", role: .destructive, action: delete)
        }
    }
}
