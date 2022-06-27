import SwiftUI
import API

struct TreeContext: ViewModifier {
    @Environment(\.editMode) private var editMode
    @State private var action: TreeActionKey.Action?
    
    func body(content: Content) -> some View {
        content
            .environment(\.treeAction, $action)
    }
}

//MARK: - Action
struct TreeActionKey: EnvironmentKey {
    enum Action: Equatable {
        case edit(Collection)
        case delete(Set<Collection>)
    }
    
    static let defaultValue: Binding<Action?> = .constant(nil)
}

extension EnvironmentValues {
    var treeAction: Binding<TreeActionKey.Action?> {
        get { self[TreeActionKey.self] }
        set { self[TreeActionKey.self] = newValue }
    }
}
