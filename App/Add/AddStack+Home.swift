import SwiftUI
import UI
import Common

extension AddStack {
    struct Home {
        @Environment(\.dismiss) private var dismiss
        @Binding var add: AddStack.Add?
        
        private var mapFiles: Binding<[URL]> {
            .init { [URL]() }
            set: { if !$0.isEmpty { add = .files($0) } }
        }
        
        private static let columns: [GridItem] = [
            .init(.adaptive(minimum: 150), spacing: 12)
        ]
    }
}

extension AddStack.Home: View {
    @ViewBuilder
    func buttons() -> some View {
        Button { add = .link() } label: {
            Label("Link", systemImage: "link")
        }
            .tint(.red)
        
        Button { add = .collection } label: {
            Label("Collection", systemImage: "folder")
        }
            .tint(.blue)
        
        MediaPicker(selection: mapFiles, matching: [.images, .videos]) {
            Label("Photos", systemImage: "photo")
        }
            .tint(.green)
        
        DocumentPicker(selection: mapFiles, matching: [.item]) {
            Label("Files", systemImage: "doc")
        }
            .tint(.indigo)
        
        NavigationLink(destination: FromApps.init) {
            Label("Add from apps", systemImage: "puzzlepiece.extension")
        }
            .tint(.secondary)
    }
    
    var body: some View {
        NavigationView {
            LazyVGrid(
                columns: Self.columns,
                spacing: Self.columns.first!.spacing,
                content: buttons
            )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .buttonStyle(.gallery)
                .symbolVariant(.fill)
                .scenePadding()
                .navigationTitle("Add")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
            .navigationViewStyle(.stack)
    }
}
