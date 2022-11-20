import SwiftUI
import API
import UI

struct RaindropFields: View {
    @EnvironmentObject private var f: FiltersStore
    @Binding var raindrop: Raindrop

    var body: some View {
        NavigationLink {
            
        } label: {
            Thumbnail(raindrop.cover?.best, height: 128, cornerRadius: 3)
                .frame(height: 128)
                .frame(maxWidth: .infinity)
        }
            .clearSection()
        
        Section {
            TextField("Title", text: $raindrop.title, axis: .vertical)
                .fontWeight(.semibold)
                .lineLimit(5)
            
            TextField("Description", text: $raindrop.excerpt, axis: .vertical)
                .lineLimit(2...5)
        }
        
        Section {
            Label {
                MultiPicker("Tags", selection: $raindrop.tags) {
                    Text($0)
                } suggestions: { filter in
                    Section("Other") {
                        ForEach(f.state.tags()) {
                            Text($0.title)
                                .tag($0.title)
                        }
                    }
                }
            } icon: {
                Image(systemName: "number")
            }
            
            Label {
                TextField("URL", value: $raindrop.link, format: .url)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            } icon: {
                Image(systemName: "globe")
            }
            
            Toggle(isOn: $raindrop.important) {
                Label("Favorite", systemImage: "heart")
                    .symbolVariant(raindrop.important ? .fill : .none)
            }
        }
            .listItemTint(.secondary)
    }
}
