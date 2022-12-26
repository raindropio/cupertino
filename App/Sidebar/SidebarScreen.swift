import SwiftUI
import API
import UI
import Common

struct SidebarScreen {
    @EnvironmentObject private var app: AppRouter
    @EnvironmentObject private var settings: SettingsRouter
    @Environment(\.horizontalSizeClass) private var sizeClass
    
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
                ToolbarItem(placement: sizeClass == .regular ? .primaryAction : .cancellationAction) {
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
