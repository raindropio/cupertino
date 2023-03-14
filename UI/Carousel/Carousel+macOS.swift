#if canImport(AppKit)
import SwiftUI

public struct Carousel<C: View>: View {
    @State private var current: Int = 0
    
    var content: () -> C
    
    public init(@ViewBuilder content: @escaping () -> C) {
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content().variadic { children in
                    ForEach(children.indices, id: \.self) { index in
                        children[index]
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .opacity(current == index ? 1 : 0)
                            .offset(x: current == index ? 0 : (current > index ? 500 : -500))
                            .transition(.opacity)
                    }
                }
            }
            
            HStack(spacing: 0) {
                content().variadic { children in
                    ForEach(children.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .opacity(current == index ? 1 : 0.3)
                            .frame(width: current == index ? 24 : 8, height: 8)
                            .padding(5)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                current = index
                            }
                    }
                }
            }
        }
            .animation(.spring(), value: current)
    }
}
#endif
