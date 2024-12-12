#if canImport(AppKit)
import SwiftUI

public struct Carousel<C: View>: View {
    @State private var current: Int = 0
    @State private var hovered = false
    
    var content: () -> C
    
    public init(@ViewBuilder content: @escaping () -> C) {
        self.content = content
    }
    
    func nav(_ icon: String, enabled: Bool, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .symbolVariant(.circle.fill)
                .symbolRenderingMode(.hierarchical)
                .font(.title)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
            .buttonStyle(.borderless)
            .padding()
            .opacity(enabled ? 1 : 0)
            .disabled(!enabled)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content().variadic { children in
                    ForEach(children.indices, id: \.self) { index in
                        children[index]
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .opacity(current == index ? 1 : 0)
                            .offset(x: current == index ? 0 : (current > index ? -500 : 500))
                            .transition(.opacity)
                    }
                }
            }
            
            HStack(spacing: 0) {
                content().variadic { children in
                    ForEach(children.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .opacity(current == index ? 1 : 0.3)
                            .frame(width: 8, height: 8)
                            .padding(5)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                current = index
                            }
                    }
                }
            }
        }
            .overlay(alignment: .leading) {
                nav("chevron.left", enabled: hovered && current > 0) { current -= 1 }
            }
            .overlay(alignment: .trailing) {
                content().variadic { children in
                    nav("chevron.right", enabled: hovered && current < children.endIndex - 1) { current += 1 }
                }
            }
            .onHover { hovered = $0 }
            .safeAnimation(.spring(), value: current)
            .safeAnimation(.default, value: hovered)
    }
}
#endif
