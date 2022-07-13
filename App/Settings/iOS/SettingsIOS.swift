import SwiftUI

#if os(iOS)
struct SettingsIOS: View {
    @EnvironmentObject private var settings: SettingsService
    @State private var path = [SettingsPage]()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                SettingsIndex()
            }
                .listStyle(.insetGrouped)
                .labelStyle(SettingsLabelStyle())
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .phone ? .large : .inline)
                .navigationDestination(for: SettingsPage.self) { page in
                    //screens
                    Group {
                        switch page {
                        case .index: EmptyView()
                        case .account: SettingsAccount()
                        case .general: EmptyView()
                        case .subscription: EmptyView()
                        case .import: EmptyView()
                        case .backups: EmptyView()
                        case .about: EmptyView()
                        }
                    }
                        .navigationTitle(page.label)
                }
                //done button
                .toolbar {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Done") {
                                dismiss()
                            }
                                .bold()
                        }
                    }
                }
        }
            //change path when selected page change
            .onAppear {
                if let page = settings.page, page != .index {
                    path = [page]
                }
            }
            .onChange(of: settings.page) {
                if let page = $0, page != .index {
                    path = [page]
                }
            }
    }
}
#endif
