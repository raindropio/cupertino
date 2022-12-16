import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen.Toolbar {
    struct Reader {
        @EnvironmentObject private var page: WebPage
        @EnvironmentObject private var r: RaindropsStore
        @AppStorage(ReaderOptions.StorageKey) private var options = ReaderOptions()
        @State private var showOptions = false
    }
}

extension PreviewScreen.Toolbar.Reader {
    func popover() -> some View {
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
            .backport.presentationDetents([.medium])
            .backport.presentationDragIndicator(.visible)
            .frame(idealWidth: 300, idealHeight: 400)
    }
}

extension PreviewScreen.Toolbar.Reader: View {
    var body: some View {
        Button {
            showOptions = true
        } label: {
            Label("Font & style", systemImage: "textformat.size")
        }
            .popover(isPresented: $showOptions, content: popover)
    }
}
