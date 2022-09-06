#if canImport(UIKit)
import UIKit
#endif

#if canImport(UIKit)
public let isPhone = UIDevice.current.userInterfaceIdiom == .phone
#else
public let isPhone = false
#endif
