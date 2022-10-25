import SwiftUI

public extension View {
    func onEvent<T>(_ name: Notification.Name, ofType: T.Type, callback: @escaping (T) -> Void) -> some View {
        modifier(OnEventModifier(name, callback: callback))
    }
}

fileprivate struct OnEventModifier<T>: ViewModifier {
    private var receiver: NotificationCenter.Publisher
    private var callback: (T) -> Void

    init(_ name: Notification.Name, callback: @escaping (T) -> Void) {
        self.callback = callback
        self.receiver = NotificationCenter.default.publisher(for: name)
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(receiver) {
                if let object = $0.object as? T {
                    callback(object)
                }
            }
    }
}
