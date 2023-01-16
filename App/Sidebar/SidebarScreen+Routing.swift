import SwiftUI
import API

extension SidebarScreen {
    struct Routing: ViewModifier {
        @EnvironmentObject private var app: AppRouter
        @Environment(\.editMode) private var editMode
        @Environment(\.splitViewSizeClass) private var sizeClass

        @Binding var selection: Set<FindBy>
        
        @Sendable func pathChange() async {
            switch app.path.first {
            case .find(let find): selection = [find]
            case .multi(_): break
            default: selection = .init()
            }
        }
        
        func selectionChange(_ selection: Set<FindBy>) {
            switch sizeClass {
            case .compact:
                if editMode?.wrappedValue == .inactive {
                    if let first = selection.first {
                        app.path = [.find(first)]
                    } else {
                        app.path = []
                    }
                }
                
            default:
                if selection.isEmpty {
                    app.path = []
                } else if selection.count == 1, let first = selection.first {
                    app.path = [.find(first)]
                    self.selection = [first]
                } else {
                    app.path = [.multi(selection.count)]
                }
            }
        }
        
        func editModeChange(_ editMode: EditMode?) {
            if sizeClass == .compact, editMode == .inactive {
                selection = .init()
            }
        }
        
        func body(content: Content) -> some View {
            content
                .task(id: app.path, pathChange)
                .onChange(of: selection, perform: selectionChange)
                .onChange(of: editMode?.wrappedValue, perform: editModeChange)
        }
    }
}
