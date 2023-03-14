#if canImport(UIKit)
import SwiftUI

public struct Carousel<C: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    var content: () -> C
    
    public init(@ViewBuilder content: @escaping () -> C) {
        self.content = content
    }
    
    public var body: some View {
        TabView(content: content)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: colorScheme == .light ? .always : .never))
    }
}
#endif
