import SwiftUI

extension ReaderOptions {
    public enum FontFamily: String, CaseIterable, Codable {
        case athelas
        case charter
        case georgia
        case monospace
        case serif //new york
        case palatino
        case sans //san franciso
        case seravek
        case times
        
        public var title: String {
            switch self {
            case .athelas: return "Athelas"
            case .charter: return "Charter"
            case .georgia: return "Georgia"
            case .palatino: return "Palatino"
            case .seravek: return "Seravek"
            case .times: return "Times New Roman"
            case .sans: return "San Francisco"
            case .serif: return "New York"
            case .monospace: return "Monospaced"
            }
        }
        
        public var preview: Font {
            switch self {
            case .athelas: return .custom("Athelas", size: 20)
            case .charter: return .custom("Charter", size: 20)
            case .georgia: return .custom("Georgia", size: 20)
            case .palatino: return .custom("Palatino", size: 20)
            case .seravek: return .custom("Seravek", size: 20)
            case .times: return .custom("Times New Roman", size: 20)
            case .sans: return .system(size: 20)
            case .serif: return .system(size: 20, design: .serif)
            case .monospace: return .system(size: 20, design: .monospaced)
            }
        }
    }
}
