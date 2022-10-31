import SwiftUI

extension ImagePicker {
    struct Columns<C: View>: View {
        var width: CGFloat?
        var content: () -> C
        
        var body: some View {
            LazyVGrid(
                columns: [.init(
                    width != nil ? .adaptive(minimum: width!) : .flexible(),
                    spacing: 16
                )],
                spacing: 16,
                content: content
            )
                .scenePadding()
        }
    }
}
