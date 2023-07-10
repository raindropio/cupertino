import SwiftUI
import API

extension ViewConfigRaindropsButton {
    struct Cover: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var cfg: ConfigStore
        @Environment(\.horizontalSizeClass) private var sizeClass

        var find: FindBy
        var view: CollectionView
        
        private var right: Binding<Bool> {
            .init {
                cfg.state.raindrops.coverRight
            } set: {
                var config = cfg.state.raindrops
                config.coverRight = $0
                dispatch.sync(ConfigAction.updateRaindrops(config))
            }
        }
        
        private func zoomIn() {
            var config = cfg.state.raindrops
            config.coverSize += 1
            dispatch.sync(ConfigAction.updateRaindrops(config))
        }
        
        private func zoomOut() {
            var config = cfg.state.raindrops
            config.coverSize -= 1
            dispatch.sync(ConfigAction.updateRaindrops(config))
        }
        
        var body: some View {
            Section {
                switch view {
                case .list, .simple:
                    Button { right.wrappedValue.toggle() } label: {
                        Label("Thumbnail \(right.wrappedValue ? "left" : "right")", systemImage: "rectangle.\(right.wrappedValue ? "left" : "right")half.inset.filled.arrow.\(right.wrappedValue ? "left" : "right")")
                    }
                    
                case .grid, .masonry:
                    if sizeClass == .regular {
                        Button(action: zoomIn) {
                            Label("Zoom in", systemImage: "plus.magnifyingglass")
                        }
                            .disabled(cfg.state.raindrops.coverSize >= 7)
                        
                        Button(action: zoomOut) {
                            Label("Zoom out", systemImage: "minus.magnifyingglass")
                        }
                            .disabled(cfg.state.raindrops.coverSize <= 1)
                    }
                }
            }
        }
    }
}
