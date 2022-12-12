import SwiftUI
import API
import UI

extension PreviewScreen.Title {
    struct Reader: View {
        @AppStorage(ReaderOptions.StorageKey) private var options = ReaderOptions()

        var body: some View {
            Form {
                Picker("Theme", selection: $options.theme) {
                    ForEach(ReaderOptions.Theme.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                
                Picker("Font", selection: $options.fontFamily) {
                    ForEach(ReaderOptions.FontFamily.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                
                Slider(value: $options.fontSize, in: 1...9, step: 1.0) {
                    Text("Size")
                }
            }
                .backport.presentationDetents([.medium])
        }
    }
}
