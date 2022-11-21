import SwiftUI
import API
import UI

struct TagsPicker: View {
    @EnvironmentObject private var f: FiltersStore
    @EnvironmentObject private var r: RecentStore
    
    @Binding var value: [String]
    
    init(_ value: Binding<[String]>) {
        self._value = value
    }

    var body: some View {
        Memorized(
            value: $value,
            recent: r.state.tags,
            suggestions: f.state.tags().compactMap(Suggestion.init)
        )
    }
}

extension TagsPicker {
    struct Memorized: View {
        @Binding var value: [String]
        var recent: [String]
        var suggestions: [Suggestion]
        
        var body: some View {
            TokenField("Tags", value: $value, recent: recent) {
                ForEach(suggestions) {
                    Text($0.rawValue)
                }
            }
        }
    }
    
    struct Suggestion: RawRepresentable, Identifiable {
        var filter: Filter
        
        init?(_ filter: Filter) {
            switch filter.kind {
            case .tag(_):
                self.filter = filter
                return
            default: break
            }
            return nil
        }
        
        init?(rawValue: String) {
            self.filter = .init(.tag(rawValue))
        }
        
        var rawValue: String {
            filter.title
        }
        
        var id: String {
            filter.id
        }
    }
}
