import SwiftUI
import API
import UI

public struct UploadFilesStack {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @State private var uploading = false
    @State private var completed = Set<URL>()
    @State private var failed = Set<URL>()
    
    var files: [URL]
    @State var collection: Int
    
    public init(_ files: [URL], collection: Int? = nil) {
        self.files = files
        self._collection = .init(initialValue: collection ?? -1)
    }
}

extension UploadFilesStack {
    @Sendable func upload() async {
        uploading = true
        defer { uploading = false }
        
        try? await dispatch(RaindropsAction
            .uploadFiles(
                files,
                collection: collection,
                completed: $completed,
                failed: $failed
            )
        )
    }
}

extension UploadFilesStack: View {
    public var body: some View {
        NavigationStack {
            ProgressView(
                value: Double(completed.count),
                total: Double(files.count)
            ) {
                Text(Double(completed.count) / Double(files.count), format: .percent)
                + Text(" complete")
            }
                .frame(width: 256)
                .scenePadding()
                .navigationTitle("Upload files")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .interactiveDismissDisabled()
                .toolbar {
                    //retry button
                    ToolbarItem(placement: .primaryAction) {
                        if !failed.isEmpty {
                            ActionButton(action: upload) {
                                Label("Retry failed", systemImage: "arrow.clockwise")
                            }
                                .tint(.red)
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
            //start uploading
            .task(id: files, priority: .background, upload)
            //auto close when complete all
            .onChange(of: completed) {
                if $0.count == files.count {
                    dismiss()
                }
            }
    }
}
