import SwiftUI

struct FakeListSelectionKey: EnvironmentKey {
    static let defaultValue : Binding<Set<AnyHashable>> = .constant([])
}

public extension EnvironmentValues {
    var fakeListSelection: Binding<Set<AnyHashable>> {
        get { self[FakeListSelectionKey.self] }
        set { self[FakeListSelectionKey.self] = newValue }
    }
}

extension FakeList {
    func fakeListSelection() -> Binding<Set<AnyHashable>> {
        .init(
            get: {
                Set(selection.map { AnyHashable($0) })
            },
            set: { newValue in
                selection = Set(newValue.compactMap { $0 as? SelectionValue })
            }
        )
    }
}
