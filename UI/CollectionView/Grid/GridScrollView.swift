import SwiftUI

struct GridScrollView<Content: View> {    
    var content: () -> Content
}

extension GridScrollView: View {
    var body: some View {
        ScrollView(.vertical) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
            //appearance
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemGroupedBackground))
    }
}
