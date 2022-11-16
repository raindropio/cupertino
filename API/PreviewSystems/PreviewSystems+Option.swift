import Foundation

extension PreviewSystems {
    public enum Option: RawRepresentable {
        case solidBackground(Bool)
        case theme(Theme)
        case fontFamily(FontFamily)
        case fontSize(Int)

        public init?(rawValue: [URLQueryItem]) {
            nil
        }
        
        public var rawValue: [URLQueryItem] {
            switch self {
            case .solidBackground(let enabled):
                return [
                    .init(name: "solid-bg", value: enabled ? "true" : "false"),
                ]
                
            case .theme(let theme):
                return [
                    .init(name: "theme", value: "\(theme)"),
                ]
                
            case .fontFamily(let fontFamily):
                return [
                    .init(name: "font-family", value: "\(fontFamily)"),
                ]
            
            case .fontSize(let fontSize):
                return [
                    .init(name: "font-size", value: "\(fontSize)"),
                ]
            }
        }
    }
    
    public enum Theme: String {
        case day
        case night
        case sunset
    }
    
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
