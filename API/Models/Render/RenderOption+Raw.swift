#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

extension RenderOption: RawRepresentable {
    public init?(rawValue: [URLQueryItem]) {
        nil
    }
    
    public var rawValue: [URLQueryItem] {
        switch self {
        case .format(let format):
            return [
                .init(name: "format", value: "\(format)"),
            ]
            
        case .dpr(let dpr):
            return [
                .init(name: "dpr", value: "\(Int(dpr))"),
            ]
            
        case .optimalSize:
            #if canImport(UIScreen)
            let maxSize = Int(min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 2)
            #elseif canImport(AppKit)
            let maxSize = Int(min(NSScreen.main?.frame.width ?? 1000, NSScreen.main?.frame.height ?? 1000) / 4)
            #else
            let maxSize = 1000
            #endif
            
            return [
                .init(name: "width", value: "\(maxSize)"),
                .init(name: "height", value: "\(maxSize)"),
            ]
            
        case .width(let width):
            return [
                .init(name: "width", value: "\(Int(width))")
            ]
            
        case .height(let height):
            return [
                .init(name: "height", value: "\(Int(height))")
            ]
        }
    }
}
