import SwiftUI

enum FakeListStyle {
    case plain
    case insetGrouped
    
    var scrollContentBackground: Color? {
        switch self {
        case .plain: return nil
        case .insetGrouped: return Color(UIColor.systemGroupedBackground)
        }
    }
    
    var itemNormalBackground: Color? {
        switch self {
        case .plain: return nil
        case .insetGrouped: return Color(UIColor.secondarySystemGroupedBackground)
        }
    }
    
    var itemSelectedBackground: Color? {
        Color(UIColor.tertiaryLabel)
    }
}

private struct FakeListStyleKey: EnvironmentKey {
    static let defaultValue : FakeListStyle = .plain
}

extension EnvironmentValues {
    var fakeListStyle: FakeListStyle {
        get { self[FakeListStyleKey.self] }
        set { self[FakeListStyleKey.self] = newValue }
    }
}
