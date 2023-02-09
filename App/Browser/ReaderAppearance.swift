import SwiftUI
import API
import UI
import Features

struct ReaderAppearance {
    @AppStorage(ReaderOptions.StorageKey) private var options = ReaderOptions()
    @Environment(\.dismiss) private var dismiss
}

extension ReaderAppearance: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: $options.theme) {
                        ForEach(ReaderOptions.Theme.allCases, id: \.rawValue) {
                            Label($0.title, systemImage: $0.systemImage)
                                .imageScale(.large)
                                .symbolVariant(.fill)
                                .tag($0)
                        }
                    } label: {}
                    .pickerStyle(.segmented)
                    .labelStyle(.iconOnly)
                }
                    .clearSection()

                Section {
                    ControlGroup {
                        Button { options.fontSize -= 1 } label: {
                            Image(systemName: "textformat.size.smaller")
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                        }
                        .disabled(options.fontSize <= 0)
                        
                        Divider()
                        
                        Button { options.fontSize += 1 } label: {
                            Image(systemName: "textformat.size.larger")
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                        }
                        .disabled(options.fontSize >= 9)
                    }
                    .controlGroupStyle(.navigation)
                    .buttonStyle(.plain)
                }
                
                Section {
                    Picker(selection: $options.fontFamily) {
                        ForEach(ReaderOptions.FontFamily.allCases, id: \.rawValue) {
                            Text($0.title)
                                .font($0.preview)
                                .tag($0)
                        }
                    } label: {
                        
                    }
                        .pickerStyle(.inline)
                }
            }
                .navigationTitle("Appearance")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: dismiss.callAsFunction)
                    }
                }
        }
            .presentationDetents([.medium])
            .frame(idealWidth: 300, idealHeight: 400)
    }
}
