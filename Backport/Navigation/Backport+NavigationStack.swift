import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    struct NavigationStack<C: View>: View {
        var content: () -> C
        
        public init(content: @escaping () -> C) {
            self.content = content
        }
        
        public var body: some View {
            if #available(iOS 16, *) {
                SwiftUI.NavigationView(content: content)
            } else {
                SwiftUI.NavigationView(content: content)
                    .navigationViewStyle(.stack)
            }
        }
    }
}
