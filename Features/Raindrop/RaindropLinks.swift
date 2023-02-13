import SwiftUI
import API
import UI

struct RaindropLinks: View {
    @Environment(\.raindropsContainer) private var container
    @Environment(\.editMode) private var editMode

    var raindrop: Raindrop

    var body: some View {
        if (
            raindrop.collection != container?.collectionId ||
            raindrop.important ||
            !raindrop.highlights.isEmpty ||
            !raindrop.tags.isEmpty
        ) {
            WStack(spacingX: 6, spacingY: 6) {
                //collection
                if raindrop.collection != container?.collectionId {
                    ItemLink(id: raindrop.collection, for: UserCollection.self) {
                        CollectionLabel(raindrop.collection).badge(0)
                    }
                        .tint(.secondary)
                }
                
                //important
                if raindrop.important {
                    SearchCompletionButton(Filter(.important)) {
                        Image(systemName: Filter.Kind.important.systemImage)
                            .symbolVariant(.fill)
                            .foregroundStyle(.tint)
                    }
                        .tint(Filter.Kind.important.color)
                }
                
                //highlights
                if !raindrop.highlights.isEmpty {
                    SearchCompletionButton(Filter(.highlights)) {
                        Label("\(raindrop.highlights.count)", systemImage: Filter.Kind.highlights.systemImage)
                    }
                        .tint(Filter.Kind.highlights.color)
                        .allowsHitTesting(false)
                }
                
                //tags
                ForEach(raindrop.tags) { tag in
                    SearchCompletionButton(Filter(.tag(tag))) {
                        Text(tag)
                    }
                }
                    .tint(Filter.Kind.notag.color)
            }
                .buttonStyle(.chip)
                .controlSize(.small)
                .imageScale(.small)
                .padding(.vertical, 4)
                .disabled(editMode?.wrappedValue == .active)
        }
    }
}
