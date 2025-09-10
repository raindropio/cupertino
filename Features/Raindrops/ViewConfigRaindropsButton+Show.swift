import SwiftUI
import API

extension ViewConfigRaindropsButton {
    struct Show: View {
        @EnvironmentObject private var cfg: ConfigStore
        
        var find: FindBy
        var view: CollectionView
        
        var body: some View {
            Memorized(raindrops: cfg.state.raindrops, hide: cfg.state.raindrops.hide, find: find, view: view)
        }
    }
}

extension ViewConfigRaindropsButton.Show {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var raindrops: ConfigRaindrops
        var hide: [CollectionView: Set<ConfigRaindrops.Element>]
        var find: FindBy
        var view: CollectionView
        
        private func isOn(_ element: ConfigRaindrops.Element) -> Binding<Bool> {
            .init {
                hide[view]?.contains(element) != true
            } set: {
                var config = raindrops
                if $0 {
                    config.hide[view]?.remove(element)
                } else {
                    config.hide[view]?.insert(element)
                }
                dispatch.sync(ConfigAction.updateRaindrops(config))
            }
        }
        
        var body: some View {
            Section("Show fields:") {
                ForEach(ConfigRaindrops.Element.allCases, id: \.rawValue) {
                    Toggle($0.title, isOn: isOn($0))
                }
            }
        }
    }
}
