import SwiftUI
import API
import UI

/// Steps to add new icon
/// 1. Add iOS icon asset to `Assets`
/// 2. Add name of asset to `App / Build Settings / Alternate App Icon Sets`

struct SettingsAppIcon: View {
    private static let available = [nil] + Bundle.alternateIcons
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
                        Image(uiImage: UIImage(named: name ?? Bundle.primaryIcon)!)
                            .resizable()
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .strokeBorder(.primary.opacity(0.2), lineWidth: 0.5)
                            )
                        
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

fileprivate extension Bundle {
    static var primaryIcon: String {
        let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: [String: Any]]
        return icons?["CFBundlePrimaryIcon"]?["CFBundleIconName"] as! String
    }
    
    static var alternateIcons: [String] {
        let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: [String: Any]]
        let names = icons?["CFBundleAlternateIcons"]?.keys
        guard let names else { return [] }
        return Array(names)
    }
}
