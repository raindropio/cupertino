import SwiftUI

public extension View {
    func infiniteScroll<D: RandomAccessCollection>(
        _ data: D,
        action: @escaping () -> Void
    ) -> some View where D.Element: Identifiable {
        modifier(InifiniteScrollModifier(data: data, action: action))
    }
}

struct InifiniteScrollModifier<D: RandomAccessCollection>: ViewModifier where D.Element: Identifiable {
    @State private var now = false

    let ids: [AnyHashable]
    let action: () -> Void

    init(data: D, action: @escaping () -> Void) {
        self.ids = data.map { $0.id }
        self.action = action
    }

    func onElementAppear(_ id: AnyHashable) {
        guard let index = ids.firstIndex(of: id)
        else { return }
        now = index >= ids.count - 15
    }

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(InfiniteScrollElementId.self, perform: onElementAppear)
            .onChange(of: now) {
                if $0 { action() }
            }
    }
}

public extension View {
    func infiniteScrollElement(_ id: AnyHashable) -> some View {
        preference(key: InfiniteScrollElementId.self, value: id)
    }
}

struct InfiniteScrollElementId: PreferenceKey {
    static var defaultValue: AnyHashable = 0

    static func reduce(value: inout AnyHashable, nextValue: () -> AnyHashable) {
        value = nextValue()
    }
}
