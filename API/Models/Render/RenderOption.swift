#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public enum RenderOption {
    case format(Format)
    case maxDeviceSize
    case width(Double)
    case height(Double)
    
    #if canImport(UIKit)
    case dpr(Double = UIScreen.main.scale)
    #else
    case dpr(Double = NSScreen.main?.backingScaleFactor ?? 1)
    #endif
}
