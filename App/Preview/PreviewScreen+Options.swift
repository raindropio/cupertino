import SwiftUI
import API
import UI

extension PreviewScreen {
    struct Options: View {
        @AppStorage(PreviewSystems.Options.StorageKey) private var options = PreviewSystems.Options()

        var body: some View {
            Form {
                Picker("Theme", selection: $options.theme) {
                    ForEach(PreviewSystems.Options.Theme.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                    }
                }
                
                Picker("Font", selection: $options.fontFamily) {
                    ForEach(PreviewSystems.Options.FontFamily.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                    }
                }
                
                Slider(value: $options.fontSize, in: 1...9, step: 1.0) {
                    Text("Size")
                }
            }
                .presentationDetents([.medium])
        }
    }
}
