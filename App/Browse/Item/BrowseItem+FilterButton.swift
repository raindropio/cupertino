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
            Group {
                if #available(iOS 16, *) {
                    Menu {
                        Label("Find \(filter.title.localizedLowercase)", systemImage: filter.systemImage)
                            .labelStyle(.titleAndIcon)
                            .backport.searchCompletion(filter)
                    } label: {
                        FilterRow(filter)
                    }
                } else {
                    Button {} label: {
                        FilterRow(filter)
                    }
                        .allowsHitTesting(false)
                }
            }
                .tint(filter.color)
        }
    }
}
