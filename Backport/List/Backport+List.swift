import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    @ViewBuilder
    static func List<S: Hashable, C: View>(
        selection: Binding<S?>,
        @ViewBuilder content: @escaping () -> C
    ) -> some View {
        _SingleList(selection: selection, content: content)
    }

    @ViewBuilder
    static func List<S: Hashable, C: View>(
        selection: Binding<Set<S>>,
        @ViewBuilder content: @escaping () -> C
    ) -> some View {
        _MultiList(selection: selection, content: content)
    }

    private struct _SingleList<S: Hashable, C: View>: View {
        @Binding var selection: S?
        @ViewBuilder var content: () -> C

        public var body: some View {
            SwiftUI.List(selection: $selection, content: content)
                .listSelectionBehaviour(selection: $selection)
        }
    }

    private struct _MultiList<S: Hashable, C: View>: View {
        @Binding var selection: Set<S>
        @ViewBuilder var content: () -> C

        public var body: some View {
            SwiftUI.List(selection: $selection, content: content)
                .listSelectionBehaviour(selection: $selection)
        }
    }
}
