import SwiftUI

extension ItemStack {
    struct ISList: View {
        @Binding public var selection: Set<S>
        @ViewBuilder public var content: () -> C
        var contextAction: ((Set<S>) -> Void)?
        
        var body: some View {
            List(selection: $selection, content: content)
                .listStyle(.plain)
        }
    }
}
