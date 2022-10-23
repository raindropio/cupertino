import SwiftUI

public struct Filter: Hashable, Equatable, Codable {
    public var kind: Kind
    public var count: Int = 0
    public var exclude = false
    
    public init(_ kind: Kind, count: Int = 0, exclude: Bool = false) {
        self.kind = kind
        self.count = count
        self.exclude = exclude
    }

    public var title: String { "\(exclude ? "Not ": "")\(kind.title)" }
    public var systemImage: String { kind.systemImage }
    public var color: Color { kind.color }
}

extension Filter: Identifiable {
    public var id: String { description }
}

//string convertible
extension Filter: CustomStringConvertible {
    public var description: String { "\(exclude ? "-" : "")\(kind)" }
}

extension Filter {
    /// Was the current filter suitable for the autocompletion of a text (sentence, phrase or word, doesn't matter)?
    /// - Returns: How much characters to remove from the end of a text (if suitable)
    public func completionEnd(of text: String) -> Int {
        let find = title.localizedLowercase
        let words = text.localizedLowercase.components(separatedBy: " ")
        for i in 0..<words.count {
            let phrase = words[i..<words.count].joined(separator: " ")
            if find.contains(phrase) {
                return phrase.count
            }
        }
        return 0
    }
    
    public func excluding(_ exclude: Bool = true) -> Self {
        var copy = self
        copy.exclude = exclude
        return copy
    }
}
