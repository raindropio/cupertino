import SwiftUI
import API

extension EnvironmentValues {
    struct RC: Equatable {
        var collectionId: Int
        var view: CollectionView
    }
    
    fileprivate struct RaindropsContainerKey: EnvironmentKey {
        static let defaultValue: RC? = nil
    }
    
    var raindropsContainer: RC? {
        get {
            self[RaindropsContainerKey.self]
        } set {
            if self[RaindropsContainerKey.self] != newValue {
                self[RaindropsContainerKey.self] = newValue
            }
        }
    }
}
