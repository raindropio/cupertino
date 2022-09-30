import SwiftUI

public enum CollectionViewLayout: Hashable {
    case list
    case grid(CGFloat, Bool)
        
    static func gap(_ layout: Self) -> CGFloat {
        20
    }
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
