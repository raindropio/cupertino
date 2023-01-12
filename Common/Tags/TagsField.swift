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
                f.state.tags().map { $0.title }.filter { !r.state.tags.contains($0) }
        )
            .reload {
                try? await dispatch(FiltersAction.reload())
            }
    }
}

extension TagsField {
    fileprivate struct Memorized: View {
        @Binding var value: [String]
        var suggestions: [String]

        var body: some View {
            TextTokenField("Tags", value: $value, suggestions: suggestions)
        }
    }
}
