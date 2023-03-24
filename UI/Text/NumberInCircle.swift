import SwiftUI

public func NumberInCircle(_ number: Int) -> Text {
    switch number {
    case 1...50:
        return .init(Image(systemName: "\(number).circle.fill"))
        
    case 0:
        return .init("")
        
    default:
        return .init(Image(systemName: "ellipsis.circle.fill"))
    }
}
