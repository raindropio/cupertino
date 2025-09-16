import SwiftUI

public struct CancelToolbarItem: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    private var action: (() -> Void)?
    
    public init() {}
    
    public init(action: @escaping @MainActor () -> Void) {
        self.action = action
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", systemImage: "xmark", role: .cancel) {
                action?()
                dismiss()
            }
                .labelStyle(.toolbar)
        }
    }
}
