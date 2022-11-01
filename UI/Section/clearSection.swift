import SwiftUI

public extension View {
    func clearSection() -> some View {
        listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listSectionSeparator(.hidden)
    }
}
