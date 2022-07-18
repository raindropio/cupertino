import SwiftUI

public extension View {
    func getLabelTitle() -> String {
        let mirror = Mirror(reflecting: self)
        for elem in mirror.children {
            if let label = elem.label,
                label == "title",
                let title = Mirror(reflecting: elem.value).descendant("storage", "anyTextStorage", "key", "key") as? String {
                return title
            }
        }
        
        return ""
    }
}
