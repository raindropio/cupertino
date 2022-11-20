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
            
        case .maxDeviceSize:
            #if canImport(UIKit)
            let maxSize = Int(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
            #else
            let maxSize = Int(max(NSScreen.main?.frame.width ?? 1000, NSScreen.main?.frame.height ?? 1000))
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
