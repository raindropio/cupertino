import Foundation

public struct IconsState: ReduxState {
    @Cached("ico-icons") var icons = [String: [URL]]()
    
    public init() {}
    
    public func filterKey(_ string: String) -> String {
        string.trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase
    }
    
    public func filtered(_ string: String) -> [URL] {
        icons[filterKey(string)] ?? .init()
    }
}
