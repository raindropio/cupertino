import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    @ViewBuilder
    static func List<S: Hashable, C: View>(
        selection: Binding<S?>,
        @ViewBuilder content: @escaping () -> C
    ) -> some View {
        if #available(iOS 16, *) {
            SwiftUI.List(selection: selection, content: content)
        } else {
            _BackportSingleList(selection: selection, content: content)
        }
    }

    @ViewBuilder
    static func List<S: Hashable, C: View>(
        selection: Binding<Set<S>>,
        @ViewBuilder content: @escaping () -> C
    ) -> some View {
        if #available(iOS 16, *) {
            SwiftUI.List(selection: selection, content: content)
        } else {
            _BackportMultiList(selection: selection, content: content)
        }
    }

    private struct _BackportSingleList<S: Hashable, C: View>: View {
        @Binding var selection: S?
        @ViewBuilder var content: () -> C

        public var body: some View {
            SwiftUI.List(selection: $selection, content: content)
                .listSelectionBehaviour(selection: $selection)
        }
    }

    private struct _BackportMultiList<S: Hashable, C: View>: View {
        @Binding var selection: Set<S>
        @ViewBuilder var content: () -> C

        public var body: some View {
            SwiftUI.List(selection: $selection, content: content)
                .listSelectionBehaviour(selection: $selection)
        }
    }
}
