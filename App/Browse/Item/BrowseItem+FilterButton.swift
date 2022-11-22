import SwiftUI
import API
import Common

extension BrowseItem {
    struct FilterButton: View {
        var filter: Filter
        
        init(_ filter: Filter) {
            self.filter = filter
        }
        
        init(kind: Filter.Kind) {
            self.filter = .init(kind)
        }
        
        var body: some View {
            Menu {
                Label("Find \(filter.title.localizedLowercase)", systemImage: filter.systemImage)
                    .labelStyle(.titleAndIcon)
                    .searchCompletion(filter)
            } label: {
                FilterRow(filter)
            }
                .tint(filter.color)
        }
    }
}
