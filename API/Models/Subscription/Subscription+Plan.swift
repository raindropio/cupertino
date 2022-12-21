extension Subscription {
    public enum Plan: String, Codable {
        case promonthly1
        case proannual1
        case unknown
        
        public var title: String {
            switch self {
            case .promonthly1: return "Pro Monthly"
            case .proannual1: return "Pro Yearly"
            case .unknown: return "Unknown"
            }
        }
    }
}
