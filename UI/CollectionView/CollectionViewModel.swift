import SwiftUI

@MainActor
class CollectionViewModel<ID: Hashable>: ObservableObject {
    @Published var selection: Set<ID> = []
    @Published var highlighted: ID?
    var isEditing: Bool = false
    
    var action: ((ID) -> Void)?
    var reorder: ((ID, Int) -> Void)?
    var contextMenu: ((Set<ID>) -> AnyView)?
    
    func touch(_ id: ID, down: Bool = false) {
        if isEditing { return }
        
        highlighted = down ? id : nil
    }
    
    func tap(_ id: ID) {
        if isEditing {
            highlighted = nil
            
            if selection.contains(id) {
                selection.remove(id)
            } else {
                selection.insert(id)
            }
        } else {
            selection = .init()
            action?(id)
        }
    }
    
    func isSelected(_ id: ID) -> Bool {
        highlighted == id || selection.contains(id)
    }
}
