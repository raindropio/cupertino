import SwiftUI

extension View {
    /// Transparent section with predictable insets that can be used everywhere (including List, ScrollView, Form, etc)
    ///
    /// ```
    /// .sectionClear()
    /// ```
    public func sectionClear() -> some View {
        modifier(SectionClearModifier())
    }
}

struct SectionClearModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            ._safeAreaInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}
