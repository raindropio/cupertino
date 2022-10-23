import SwiftUI

struct TriggerSubmitKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    public var onSubmitAction: () -> Void {
        get {
            self[TriggerSubmitKey.self]
        } set {
            let oldValue = self[TriggerSubmitKey.self]
            self[TriggerSubmitKey.self] = {
                oldValue()
                newValue()
            }
        }
    }
}

public extension View {
    func onSubmit(_ action: @escaping (() -> Void)) -> some View {
        onSubmit(of: .text, action)
            .environment(\.onSubmitAction, action)
    }
}
