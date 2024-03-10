import SwiftUI
import API
import UI
import Features
import Backport

struct ReaderAppearance {
    @AppStorage(ReaderOptions.StorageKey) private var options = ReaderOptions()
    @Environment(\.dismiss) private var dismiss
}

extension ReaderAppearance: View {
    var body: some View {
        NavigationStack {
            List {
                HStack(spacing: 24) {
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
                    
                    Stepper(value: $options.fontSize, in: 0...9) {}
                        .labelsHidden()
                }
                    .padding(.bottom, 8)
                    .listSectionSeparator(.hidden)
                
                Section {
                    Picker(selection: $options.fontFamily) {
                        ForEach(ReaderOptions.FontFamily.allCases, id: \.rawValue) {
                            Text($0.title)
                                .font($0.preview)
                                .tag($0)
                        }
                    } label: {}
                        .pickerStyle(.inline)
                }
            }
                .listStyle(.plain)
                .navigationTitle("Appearance")
                #if canImport(UIKit)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    DoneToolbarItem()
                }
        }
            .presentationDetents([.medium])
            .backport.presentationCompactAdaptation(.none)
            .frame(idealWidth: 500, idealHeight: 400)
    }
}
