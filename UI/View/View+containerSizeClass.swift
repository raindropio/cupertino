import SwiftUI

public extension View {
    func containerSizeClass() -> some View {
        modifier(ContainerSizeClass())
    }
}

fileprivate struct ContainerSizeClass: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    func body(content: Content) -> some View {
        content
            .environment(\.containerHorizontalSizeClass, horizontalSizeClass)
    }
}

public extension EnvironmentValues {
    private struct ContainerHorizontalSizeClassKey: EnvironmentKey {
        static let defaultValue: UserInterfaceSizeClass? = nil
    }
    
    var containerHorizontalSizeClass: UserInterfaceSizeClass? {
        get {
            self[ContainerHorizontalSizeClassKey.self]
        }
        set {
            if self[ContainerHorizontalSizeClassKey.self] != newValue {
                self[ContainerHorizontalSizeClassKey.self] = newValue
            }
        }
    }
}
