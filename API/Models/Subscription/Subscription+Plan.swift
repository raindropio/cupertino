extension Subscription {
    public enum Plan: String, Codable {
        case promonthly1
        case proannual1
        case unknown
        
        public var title: String {
            switch self {
            case .promonthly1: return String(localized: "Pro Monthly")
            case .proannual1: return String(localized: "Pro Yearly")
            case .unknown: return String(localized: "Unknown")
            }
        }
    }
}
