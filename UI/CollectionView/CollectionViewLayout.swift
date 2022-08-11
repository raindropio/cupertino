import SwiftUI

public enum CollectionViewLayout: Hashable {
    case list
    case grid(CGFloat)
}

private struct CollectionViewLayoutKey: EnvironmentKey {
    static let defaultValue: CollectionViewLayout? = nil
}

extension EnvironmentValues {
    var collectionViewLayout: CollectionViewLayout? {
        get { self[CollectionViewLayoutKey.self] }
        set { self[CollectionViewLayoutKey.self] = newValue }
    }
}
