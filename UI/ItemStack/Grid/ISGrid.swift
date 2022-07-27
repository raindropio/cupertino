import SwiftUI

extension ItemStack {
    struct ISGrid: View {
        @Binding var selection: Set<S>
        @ViewBuilder var content: () -> C
        
        var body: some View {
            FakeList(selection: $selection) {
                content()
            }
                .listStyle(.insetGrouped)
        }
    }
}
