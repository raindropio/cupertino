import SwiftUI

public struct DoneToolbarItem: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}

    public var body: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Done", action: dismiss.callAsFunction)
                .fontWeight(.semibold)
        }
    }
}
