import SwiftUI
import API
import UI

/// Steps to add new icon
/// 1. Add iOS icon asset to `Assets`
/// 2. Add name to `available` array

struct SettingsAppIcon: View {
    private static let primary = "AppIcon"
    private static let available = [nil, "Flow", "Holo", "Blue", "Black", "Zen", "Pinky"]
    @State private var selection = UIApplication.shared.alternateIconName
    
    @Sendable
    @MainActor
    private func update() async {
        guard selection != UIApplication.shared.alternateIconName else { return }
        try? await UIApplication.shared.setAlternateIconName(selection)
    }
    
    var body: some View {
        List {
            Picker(selection: $selection) {
                ForEach(Self.available, id: \.self) { name in
                    HStack(spacing: 16) {
                        if let uiImage = UIImage(named: name ?? Self.primary) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .strokeBorder(.primary.opacity(0.2), lineWidth: 0.5)
                                )
                        }
                        
                        Text(name ?? "Default")
                    }
                        .padding(.vertical, 4)
                        .tag(name)
                }
            } label: {}
                .pickerStyle(.inline)
                .listSectionSeparator(.hidden)
        }
            .listStyle(.plain)
            .navigationTitle("App Icon")
            .task(id: selection, update)
    }
}
