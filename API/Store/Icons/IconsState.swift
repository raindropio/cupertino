import Foundation

public struct IconsState: ReduxState {
    @Cached("ico-icons") var icons = [String: [URL]]()
    var loading = [String: Bool]()
    
    public init() {}
    
    public func filterKey(_ string: String) -> String {
        string.trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase
    }
    
    public func filtered(_ string: String) -> [URL] {
        icons[filterKey(string)] ?? .init()
    }
    
    public func loading(_ string: String) -> Bool {
        loading[filterKey(string)] ?? false
    }
}
