import SwiftUI

public extension View {
    /// Prefer to put this modifier to last
    func restoreSceneValue<V: Codable & Equatable>(_ key: String, value: Binding<V>) -> some View {
        modifier(RestoreSceneValue(key, value: value))
    }
}

fileprivate struct RestoreSceneValue<V: Codable & Equatable>: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @SceneStorage private var sceneId: String
    @State private var loaded = false
    
    @Binding var value: V
    
    init(_ key: String, value: Binding<V>) {
        self._sceneId = .init(wrappedValue: UUID().uuidString, key)
        self._value = value
    }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var fileURL: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("RestoreScene-\(sceneId).json", isDirectory: false)
    }
    
    private func restore() {
        defer { loaded = true }
        guard
            let fileURL,
            let data = FileManager.default.contents(atPath: fileURL.path),
            let decoded = try? decoder.decode(V.self, from: data)
        else { return }
        if decoded != value {
            value = decoded
        }
    }
    
    private func save() {
        guard let fileURL else { return }
        try? FileManager.default.removeItem(at: fileURL)
        if let encoded = try? encoder.encode(value) {
            FileManager.default.createFile(atPath: fileURL.path, contents: encoded, attributes: nil)
        }
    }
    
    func body(content: Content) -> some View {
        Group {
            if loaded {
                content
            } else {
                Color.clear
            }
        }
            .onAppear(perform: restore)
            .onDisappear(perform: save)
            .onChange(of: scenePhase) {
                switch $0 {
                case .background:
                    save()
                default:
                    break
                }
            }
    }
}

