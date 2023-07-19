import SwiftUI

public struct CancelToolbarItem: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}

    public var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(role: .cancel, action: dismiss.callAsFunction) {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title3)
                    .fontWeight(.medium)
            }
                .tint(.secondary)
        }
    }
}
