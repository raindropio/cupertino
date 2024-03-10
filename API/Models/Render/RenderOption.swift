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
    
    #if canImport(UIScreen)
    case dpr(Double = UIScreen.main.scale)
    #elseif canImport(AppKit)
    case dpr(Double = .init(NSScreen.main?.backingScaleFactor ?? 1))
    #else
    case dpr(Double = 3.0)
    #endif
}
