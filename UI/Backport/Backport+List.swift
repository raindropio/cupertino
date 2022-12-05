import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    struct List<S: Hashable, C: View>: View {
        @Binding var selection: S?
        var content: () -> C
        
        public init(selection: Binding<S?>, @ViewBuilder content: @escaping () -> C) {
            self._selection = selection
            self.content = content
        }
    }
}

extension Backport.List {
    public var body: some View {
        SwiftUI.List(selection: $selection, content: content)
            .environment(\.backportListSelection,
                .init {
                    selection as AnyHashable
                } set: {
                    selection = $0 as? S
                }
            )
    }
}

fileprivate struct ListSelectionKey: EnvironmentKey {
    static let defaultValue: Binding<AnyHashable?> = .constant(nil)
}

extension EnvironmentValues {
    var backportListSelection: Binding<AnyHashable?> {
        get {
            self[ListSelectionKey.self]
        }
        set {
            if self[ListSelectionKey.self].wrappedValue != newValue.wrappedValue {
                self[ListSelectionKey.self] = newValue
            }
        }
    }
}
