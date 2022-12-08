import Foundation

extension URL {
    public static func detect(from string: String) -> [Self] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        return detector?
            .matches(
                in: string,
                options: [],
                range: NSRange(location: 0, length: string.utf16.count)
            )
            .compactMap {
                $0.url
            } ?? []
    }
    
    public static func detect(from string: String) -> Self? {
        let matches: [Self] = detect(from: string)
        return matches.first
    }
}
