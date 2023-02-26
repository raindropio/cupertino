import SwiftUI
import API

extension ViewConfigRaindropsButton {
    struct Show: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var cfg: ConfigStore
        
        var find: FindBy
        var view: CollectionView
        
        private func isOn(_ element: ConfigRaindrops.Element) -> Binding<Bool> {
            .init {
                cfg.state.raindrops.hide[view]?.contains(element) != true
            } set: {
                var config = cfg.state.raindrops
                if $0 {
                    config.hide[view]?.remove(element)
                } else {
                    config.hide[view]?.insert(element)
                }
                dispatch.sync(ConfigAction.updateRaindrops(config))
            }
        }
        
        var body: some View {
            Menu {
                ForEach(ConfigRaindrops.Element.allCases, id: \.rawValue) {
                    Toggle($0.title, isOn: isOn($0))
                }
            } label: {
                Label("Show in \(view.title.localizedLowercase)", systemImage: "eye")
            }
        }
    }
}
