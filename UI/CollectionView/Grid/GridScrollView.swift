import SwiftUI

struct GridScrollView<Content: View> {
    var content: () -> Content
}

extension GridScrollView: View {
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
                .environment(\.gridScrollSize, geo.size)
                //appearance
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
