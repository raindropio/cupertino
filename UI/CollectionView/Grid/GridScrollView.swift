import SwiftUI

struct GridScrollView<Content: View> {
    @ScaledMetric private var gap = CollectionViewLayout.gap(.grid(0, false))

    var content: () -> Content
}

extension GridScrollView: View {
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                content()
                    //size / insets
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    ._safeAreaInsets(.init(top: 0, leading: gap, bottom: 0, trailing: gap))
            }
                .environment(\.gridScrollSize, geo.size)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //appearance
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

//MARK: - Size
private struct GridScrollSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var gridScrollSize: CGSize {
        get { self[GridScrollSizeKey.self] }
        set { self[GridScrollSizeKey.self] = newValue }
    }
}
