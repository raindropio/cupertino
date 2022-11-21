import SwiftUI

public enum TokenFieldStyle {
    case automatic
    case inline
    case menu
}

public extension View {
    func tokenFieldStyle(_ style: TokenFieldStyle) -> some View {
        environment(\.tokenFieldStyle, style)
    }
}

private struct TokenFieldStyleKey: EnvironmentKey {
    static let defaultValue: TokenFieldStyle = .automatic
}

public extension EnvironmentValues {
    var tokenFieldStyle: TokenFieldStyle {
        get { self[TokenFieldStyleKey.self] }
        set {
            if self[TokenFieldStyleKey.self] != newValue {
                self[TokenFieldStyleKey.self] = newValue
            }
        }
    }
}
