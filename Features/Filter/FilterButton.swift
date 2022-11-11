import SwiftUI
import API

struct FilterButton: View {
    @EnvironmentObject private var app: AppRouter
    
    var filter: Filter
    
    init(_ filter: Filter) {
        self.filter = filter
    }
    
    init(kind: Filter.Kind) {
        self.filter = .init(kind)
    }
    
    var body: some View {
        Menu {
            Group {
                switch filter.kind {
                case .duplicate(let of) where of != nil:
                    Button {
                        app.push(.browse(.init(
                            Filter(.raindrop(of!))
                        )))
                    } label: {
                        Label("Find original", systemImage: "star")
                    }
                    
                    Button {
                        app.push(.browse(.init(filter)))
                    } label: {
                        Label("Find similar", systemImage: filter.systemImage)
                    }
                    
                default:
                    Button {
                        app.push(.browse(.init(filter)))
                    } label: {
                        Label("Find \(filter.title.localizedLowercase)", systemImage: filter.systemImage)
                    }
                }
            }
                .labelStyle(.titleAndIcon)
        } label: {
            FilterItem(filter)
        }
            .tint(filter.color)
    }
}
