import SwiftUI
import API
import UI

struct TagsField: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var f: FiltersStore
    @EnvironmentObject private var r: RecentStore

    @Binding var value: [String]
    
    init(_ value: Binding<[String]>) {
        self._value = value
    }
    
    var body: some View {
        Memorized(
            value: $value,
            suggestions:
                (r.state.tags.isEmpty ? [] : r.state.tags + [""]) +
                f.state.tags().filter { $0.kind != .notag }.map { $0.title }.filter { !r.state.tags.contains($0) }
        )
            .reload(priority: .background) {
                try? await dispatch(
                    FiltersAction.reload(),
                    RecentAction.reload()
                )
            }
    }
}

extension TagsField {
    fileprivate struct Memorized: View {
        @Binding var value: [String]
        var suggestions: [String]

        var body: some View {
            TextTokenField(value: $value, suggestions: suggestions, prompt: "Tags")
        }
    }
}
