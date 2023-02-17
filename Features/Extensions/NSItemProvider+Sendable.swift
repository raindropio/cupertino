import Foundation

extension NSItemProvider: @unchecked Sendable {}

extension Array: @unchecked Sendable where Element == NSItemProvider {}
