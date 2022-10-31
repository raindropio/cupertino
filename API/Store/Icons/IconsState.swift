import Foundation

public struct IconsState: Equatable {
    @Cached("ico-icons") var icons = [String: [URL]]()
    
    public func filterKey(_ string: String) -> String {
        string.trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase
    }
    
    public func icons(_ string: String) -> [URL] {
        icons[filterKey(string)] ?? .init()
    }
}
