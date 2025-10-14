import SwiftUI
import API
import UI

public struct FilterRaindropsButton: View {
    @EnvironmentObject private var f: FiltersStore
    @EnvironmentObject private var dispatch: Dispatcher

    @Binding var find: FindBy
    @Binding var show: Bool
    
    public init(_ find: Binding<FindBy>, show: Binding<Bool>) {
        self._find = find
        self._show = show
    }

    public var body: some View {
        Button("Filter", systemImage: find.filters.isEmpty ? "line.3.horizontal.decrease" : "line.3.horizontal.decrease.circle.fill") {
            show = true
        }
            .tint(find.filters.isEmpty ? nil : .accentColor)
            .help("Filter")
    }
}
