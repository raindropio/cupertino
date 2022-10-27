import Foundation

#if canImport(UIKit)
import UIKit
fileprivate let scaleFactor = UIScreen.main.scale
#else
import AppKit
fileprivate let scaleFactor = NSScreen.main?.backingScaleFactor ?? 1
#endif

extension Render {
    enum Option: RawRepresentable {
        case format(Format = .avif)
        case dpr(CGFloat = scaleFactor)
        case maxDeviceSize
        case width(CGFloat)
        case height(CGFloat)

        init?(rawValue: [URLQueryItem]) {
            nil
        }
        
        var rawValue: [URLQueryItem] {
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
        
        typealias RawValue = [URLQueryItem]
    }
    
    enum Format: String {
        case avif
    }
}
