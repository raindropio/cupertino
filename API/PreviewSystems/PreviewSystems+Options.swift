import Foundation
import SwiftUI

extension PreviewSystems {
    public struct Options {
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
    }
}

//AppStorage support
extension PreviewSystems.Options: RawRepresentable, Hashable {
    public static var StorageKey: String {
        "preview-systems-options"
    }
    
    public var rawValue: String {
        var components = URLComponents()
        components.queryItems = query
        return components.query ?? ""
    }

    public init?(rawValue: String) {
        var components = URLComponents()
        components.query = rawValue
        
        if let val = components.queryItems?.first { $0.name == "font-size" }?.value,
            let fontSize = Double(val) {
            self.fontSize = fontSize
        }
    }
}

extension PreviewSystems.Options {
    public enum Theme: String, CaseIterable {
        case day
        case night
        case sunset
        
        public var colorScheme: ColorScheme {
            switch self {
            case .day, .sunset: return .light
            case .night: return .dark
            }
        }
    }
}

extension PreviewSystems.Options {
    public enum FontFamily: String, CaseIterable {
        case serif
        case palatino
        case times = "times new roman"
        case trebuchet = "trebuchet ms"
        case georgia
        case verdana
        case monospace
    }
}
