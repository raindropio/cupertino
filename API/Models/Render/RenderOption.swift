#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public enum RenderOption: Equatable {
    case format(Format)
    case optimalSize
    case width(Double)
    case height(Double)
    
    #if canImport(UIKit)
    case dpr(Double = UIScreen.main.scale)
    #else
    case dpr(Double = .init(NSScreen.main?.backingScaleFactor ?? 1))
    #endif
}
