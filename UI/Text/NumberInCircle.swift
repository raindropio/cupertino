import SwiftUI

public func NumberInCircle(_ number: Int) -> Text {
    if number != 0 {
        return .init(Image(systemName: "\(number).circle.fill"))
    } else {
        return .init("")
    }
}
