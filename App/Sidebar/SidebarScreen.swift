import SwiftUI
import API
import UI
import Common

struct SidebarScreen {
    @EnvironmentObject private var app: AppRouter
    @EnvironmentObject private var settings: SettingsRouter
    @Environment(\.editMode) private var editMode
    
    @State private var selection = Set<FindBy>()
}

extension SidebarScreen {
    @Sendable func pathChange() async {
        switch app.path.first {
        case .browse(let find): selection = [find]
        default: selection = .init()
        }
    }
    
    func selectionChange(_ selection: Set<FindBy>) {
        guard editMode?.wrappedValue != .active
        else { return }
                
        if let first = selection.first {
            app.path = [.browse(first)]
        } else {
            app.path = []
        }
    }
}

extension SidebarScreen: View {
    var body: some View {
        FindByPicker(selection: $selection)
            .task(id: app.path, pathChange)
            .onChange(of: selection, perform: selectionChange)
            .modifier(Phone())
            .navigationTitle("Collections")
            .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
            .toolbar {
                ToolbarItem(placement: isPhone ? .cancellationAction : .primaryAction) {
                    Button {
                        settings.open()
                    } label: {
                        MeLabel()
                            .labelStyle(.iconOnly)
                    }
                }
            }
    }
}
