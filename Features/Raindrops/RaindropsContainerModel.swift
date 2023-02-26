import SwiftUI
import API

extension EnvironmentValues {
    struct RC: Equatable {
        var find: FindBy
        var view: CollectionView
        var hide: Set<ConfigRaindrops.Element>
        var coverRight: Bool = false
        var coverWidth: Double
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
