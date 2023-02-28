import SwiftUI
import API
import UI

public struct RaindropHighlights: View {
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    public var body: some View {
        Group {
            if raindrop.highlights.isEmpty {
                EmptyState("No highlights", message: "Annotate web and easily revisit key passages in the future") {
                    Image(systemName: Filter.Kind.highlights.systemImage)
                        .foregroundStyle(Filter.Kind.highlights.color)
                } actions: {
                    SafariLink("Learn more", destination: URL(string: "https://help.raindrop.io/highlights")!)
                }
                    .scenePadding()
            } else {
                List {
                    ForEach($raindrop.highlights, content: HighlightEditRow.init)
                        .listSectionSeparator(.hidden)
                }
                    .listStyle(.plain)
            }
        }
            .navigationTitle(Filter.Kind.highlights.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
