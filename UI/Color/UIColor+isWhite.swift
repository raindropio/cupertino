#if canImport(UIKit)
import UIKit

extension UIColor {
    var isWhite: Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return false
        }

        let tol: CGFloat = 0.0001
        return abs(r - 1) < tol &&
               abs(g - 1) < tol &&
               abs(b - 1) < tol &&
               abs(a - 1) < tol
    }
}
#endif
