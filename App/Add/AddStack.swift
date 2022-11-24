import SwiftUI
import UI
import Common

struct AddStack: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var tab: Tab?
    var collection: Int?
    
    init(tab: Tab? = nil, collection: Int? = nil) {
        self._tab = .init(initialValue: tab)
        self.collection = collection == 0 ? -1 : collection
    }

    var body: some View {
        Group {
            switch tab {
            case .url:
                AddURLStack(collection: collection)
                
            case .collection:
                CreateCollectionStack(collection != nil ? .parent(collection!) : .group())
                
            case nil:
                Home(tab: $tab)
            }
        }
        .frame(idealWidth: 400, idealHeight: 340)
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.hidden)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: tab)
    }
}

extension AddStack {
    enum Tab {
        case url
        case collection
    }
}

extension AddStack {
    struct Home: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var tab: AddStack.Tab?
        
        var body: some View {
            NavigationStack {
                LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    Button { tab = .url } label: {
                        Label("Link", systemImage: "link")
                    }
                    .tint(.red)
                    
                    Button { tab = .collection } label: {
                        Label("Collection", systemImage: "folder")
                    }
                        .tint(.blue)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .buttonStyle(.gallery)
                    .symbolVariant(.fill)
                    .scenePadding()
                    .navigationTitle("New")
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { dismiss() }
                        }
                    }
            }
        }
    }
}
