import Foundation
import SwiftUI

public struct ReaderOptions {
    public var solidBackground = false
    public var theme: Theme?
    public var fontFamily: FontFamily?
    public var fontSize: Double = 1
    
    public init() {}
    
    public var query: [URLQueryItem] {
        var items: [URLQueryItem] = [
            .init(name: "solid-bg", value: solidBackground ? "true" : "false"),
            .init(name: "font-size", value: "\(fontSize)")
        ]
        
        if let theme {
            items.append(.init(name: "theme", value: "\(theme)"))
        }
        
        if let fontFamily {
            items.append(.init(name: "font-family", value: "\(fontFamily)"))
        }
        
        return items
    }
    
    public static var StorageKey: String {
        "preview-systems-options"
    }
}

extension ReaderOptions: Hashable {}
