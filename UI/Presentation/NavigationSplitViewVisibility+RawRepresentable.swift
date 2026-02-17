import SwiftUI

fileprivate let mapping: [Int: NavigationSplitViewVisibility] = [
    1: .all,
    2: .detailOnly,
    3: .doubleColumn
]

extension NavigationSplitViewVisibility: @retroactive RawRepresentable {
    public init?(rawValue: Int) {
        self = mapping[rawValue] ?? .automatic
    }
    
    public var rawValue: Int {
        mapping.first { $0.value == self }?.key ?? 0
    }
}
