import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func navigationDestination<V: Hashable, C: View>(for type: V.Type, @ViewBuilder destination: @escaping (V) -> C) -> some View {
        if #available(iOS 16, *) {
            content.navigationDestination(for: type, destination: destination)
        } else {
            content.modifier(Sequence(type: type, destination: destination))
        }
    }
}

fileprivate struct Sequence<V: Hashable, C: View>: ViewModifier {
    @EnvironmentObject private var service: BackportNavigationService
    var type: V.Type
    var level = 0
    var destination: (V) -> C
    
    var isPresented: Binding<Bool> {
        .init {
            level <= service.path.count-1
        } set: {
            if !$0 {
                service.path.removeSubrange(level...)
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .background(
                SwiftUI.NavigationLink("", isActive: isPresented) {
                    if isPresented.wrappedValue, let value = service.path[level] as? V {
                        destination(value)
                            .modifier(Self(type: type, level: level+1, destination: destination))
                    }
                }
            )
    }
}
