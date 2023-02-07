import SwiftUI
import API
import UI
import Features

struct ReaderAppearance {
    @AppStorage(ReaderOptions.StorageKey) private var options = ReaderOptions()
}

extension ReaderAppearance: View {
    var body: some View {
        Form {
            Picker("Theme", selection: $options.theme) {
                ForEach(ReaderOptions.Theme.allCases, id: \.rawValue) {
                    Image(systemName: $0.systemImage)
                        .imageScale(.large)
                        .symbolVariant(.fill)
                        .tag($0)
                }
            }
                .pickerStyle(.segmented)
                .clearSection()
            
            Section {
                Slider(value: $options.fontSize, in: 0...9, step: 1.0) {
                    Text("Size")
                } minimumValueLabel: {
                    Image(systemName: "textformat.size.smaller")
                } maximumValueLabel: {
                    Image(systemName: "textformat.size.larger")
                }
            }
            
            Picker("Font", selection: $options.fontFamily) {
                ForEach(ReaderOptions.FontFamily.allCases, id: \.rawValue) {
                    Text($0.title)
                        .font($0.preview)
                        .tag($0)
                }
            }
                .pickerStyle(.inline)
        }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .frame(idealWidth: 300, idealHeight: 400)
    }
}
