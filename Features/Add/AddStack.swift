import SwiftUI
import API
import UI

public struct AddStack {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var c: CollectionsStore
    @AppStorage("last-used-collection") private var lastUsedCollection: Int?
    
    @State private var uploading = false
    @State private var completed = Set<URL>()
    @State private var failed = Set<URL>()
    
    var urls: Set<URL>
    @State var collection: Int
    
    public init(_ urls: Set<URL>, to collection: Int? = nil) {
        self.urls = urls
        self._collection = .init(initialValue: collection ?? -1)
    }
}

extension AddStack {
    private var isCompleteAll: Bool {
        completed.count == urls.count
    }
    
    @Sendable
    private func upload() async {
        uploading = true
        defer { uploading = false }
        
        lastUsedCollection = collection
        
        try? await dispatch(
            RaindropsAction.add(
                urls,
                collection: collection,
                completed: $completed,
                failed: $failed
            )
        )
    }
}

extension AddStack: View {
    public var body: some View {
        NavigationStack {
            VStack {
                Group {
                    if isCompleteAll {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 56, weight: .semibold))
                    } else {
                        if urls.count == 1 {
                            ProgressView()
                        } else {
                            ProgressView(
                                value: Double(completed.count),
                                total: Double(urls.count)
                            ) {
                                Text(Double(completed.count) / Double(urls.count), format: .percent)
                                + Text(" complete")
                            }
                                .frame(width: 256)
                        }
                    }
                }
                    .transition(.scale(scale: 1.5).combined(with: .opacity))
                
                if !failed.isEmpty {
                    ActionButton(action: upload) {
                        Label("Retry failed", systemImage: "arrow.clockwise")
                    }
                    .tint(.red)
                }
            }
                .scenePadding()
                .navigationTitle("Add to \(c.state.title(collection))")
                #if canImport(UIKit)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    CancelToolbarItem()
                }
        }
            .animation(.spring(), value: isCompleteAll)
            .interactiveDismissDisabled(!isCompleteAll)
            //start uploading
            .task(id: urls, priority: .background, upload)
            //auto close when complete all
            .task(id: isCompleteAll) {
                if isCompleteAll {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    dismiss()
                }
            }
    }
}
