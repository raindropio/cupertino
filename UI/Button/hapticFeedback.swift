import SwiftUI

#if os(iOS)
public extension EnvironmentValues {
    var hapticFeedback: HapticFeedback {
        self[HapticFeedbackKey.self]
    }
}

public class HapticFeedback {
    private var cache: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    
    public func callAsFunction(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if cache[style] == nil {
            cache[style] = .init(style: style)
        }
        cache[style]?.impactOccurred()
    }
}

private struct HapticFeedbackKey: EnvironmentKey {
    static let defaultValue: HapticFeedback = .init()
}
#endif
