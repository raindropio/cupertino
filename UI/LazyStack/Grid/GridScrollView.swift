import SwiftUI

struct GridScrollView<Content: View> {
    @Environment(\.lazyStackLayout) private var layout
    var content: () -> Content
}

extension GridScrollView: View {
    var body: some View {
        if case .grid(let width, _) = layout {
            GeometryReader { geo in
                ScrollView(.vertical) {
                    content()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .environment(\.gridScrollColumns, max(Int(geo.size.width / width), 2))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(Color.groupedBackground)
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
