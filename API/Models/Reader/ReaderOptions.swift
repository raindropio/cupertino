import Foundation
import SwiftUI

public struct ReaderOptions {
    public var theme: Theme = .system
    public var fontFamily: FontFamily = .sans
    public var fontSize: Double = 1
    
    public init() {}
    
    public var query: [URLQueryItem] {
        var items: [URLQueryItem] = [
            .init(name: "font-size", value: "\(fontSize)")
        ]
        
        items.append(.init(name: "theme", value: "\(theme)"))
        if theme != .system {
            items.append(.init(name: "solid-bg", value: "true"))
        }
        
        items.append(.init(name: "font-family", value: "\(fontFamily)"))
        
        return items
    }
    
    public static var StorageKey: String {
        "preview-systems-options"
    }
}

extension ReaderOptions: Hashable {}
