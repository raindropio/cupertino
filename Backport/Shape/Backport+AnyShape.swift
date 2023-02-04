import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    static func AnyShape<S: Shape>(_ shape: S) -> some Shape {
        if #available(iOS 16.0, *) {
            return SwiftUI.AnyShape(shape)
        } else {
            return BackportAnyShape(shape)
        }
    }
}

fileprivate struct BackportAnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}
