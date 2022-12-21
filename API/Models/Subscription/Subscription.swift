import Foundation

public struct Subscription: Identifiable, Equatable {
    public var id: String
    public var status: Status
    public var plan: Plan
    public var renewAt: Date?
    public var stopAt: Date?
    public var price: Price
    public var links: Links
}
