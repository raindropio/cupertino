import SwiftUI

struct GridScrollView<Content: View> {
    @Environment(\.collectionViewLayout) private var layout
    @ScaledMetric private var gap = CollectionViewLayout.gap(.grid(0, false))

    var content: () -> Content
}

extension GridScrollView: View {
    var body: some View {
        if case .grid(let width, _) = layout {
            GeometryReader { geo in
                ScrollView(.vertical) {
                    content()
                    //size / insets
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        ._safeAreaInsets(.init(top: 0, leading: gap, bottom: 0, trailing: gap))
                }
                .environment(\.gridScrollColumns, max(Int(geo.size.width / width), 2))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //appearance
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGroupedBackground))
            }
        }
    }
}

//MARK: - Size
private struct GridScrollColumnsKey: EnvironmentKey {
    static let defaultValue: Int = 2
}

extension EnvironmentValues {
    var gridScrollColumns: Int {
        get { self[GridScrollColumnsKey.self] }
        set { self[GridScrollColumnsKey.self] = newValue }
    }
}
