import Foundation

extension Raindrop {
    public struct Cache: Codable, Equatable, Hashable {
        public var size: Int?
        public var created: Date?
        public var status: Status?
        
        public enum Status: String, Codable {
            case ready
            case originUnreachable = "invalid-origin"
            case sizeLimit = "invalid-size"
            case timeout = "invalid-timeout"
            case failed
            
            public var title: String {
                switch self {
                case .ready: return String(localized: "Ready")
                case .originUnreachable: return String(localized: "Origin is unreachable")
                case .sizeLimit: return String(localized: "Page size is larger than allowed")
                case .timeout: return String(localized: "Request timeout")
                case .failed: return String(localized: "Unable to save copy after several failed attempts")
                }
            }
        }
    }
}
