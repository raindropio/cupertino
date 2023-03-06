import SwiftUI

struct GridScrollView<Content: View> {
    var content: () -> Content
}

extension GridScrollView: View {
    var body: some View {        
        ScrollView(.vertical) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.groupedBackground)
            .modifier(ColumnsReader())
    }
}

struct ColumnsReader: ViewModifier {
    @Environment(\.lazyStackLayout) private var layout

    func body(content: Content) -> some View {
        if case .grid(let width, _) = layout {
            GeometryReader { geo in
                content
                    .environment(\.gridScrollColumns, max(Int(geo.size.width / width), 2))
            }
        } else {
            content
        }
    }
}

//MARK: - Size
private struct GridScrollColumnsKey: EnvironmentKey {
    static let defaultValue: Int = 2
}

extension EnvironmentValues {
    var gridScrollColumns: Int {
        get {
            self[GridScrollColumnsKey.self]
        }
        set {
            if self[GridScrollColumnsKey.self] != newValue {
                self[GridScrollColumnsKey.self] = newValue
            }
        }
    }
}
