import SwiftUI

public struct Filter: Hashable, Equatable, Codable {
    public var kind: Kind
    public var count: Int = 0
    
    public init(_ kind: Kind, count: Int = 0) {
        self.kind = kind
        self.count = 0
    }

    public var title: String { kind.title }
    public var systemImage: String { kind.systemImage }
    public var color: Color { kind.color }
}

extension Filter: Identifiable {
    public var id: String { description }
}

//string convertible
extension Filter: CustomStringConvertible {
    public var description: String { "\(kind)" }
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
}
