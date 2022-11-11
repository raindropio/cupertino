import SwiftUI

public enum MultiPickerStyle {
    case automatic
    case inline
    case menu
}

public extension View {
    func multiPickerStyle(_ style: MultiPickerStyle) -> some View {
        environment(\.multiPickerStyle, style)
    }
}

private struct MultiPickerStyleKey: EnvironmentKey {
    static let defaultValue: MultiPickerStyle = .automatic
}

public extension EnvironmentValues {
    var multiPickerStyle: MultiPickerStyle {
        get { self[MultiPickerStyleKey.self] }
        set {
            if self[MultiPickerStyleKey.self] != newValue {
                self[MultiPickerStyleKey.self] = newValue
            }
        }
    }
}
