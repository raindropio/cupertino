import SwiftUI
import API
import UI

struct RaindropLinks: View {
    @Environment(\.openDeepLink) private var openDeepLink
    @Environment(\.raindropsContainer) private var container
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif

    var raindrop: Raindrop
    
    private func tapFilter(_ kind: Filter.Kind) {
        guard let find = container?.find else { return }
        openDeepLink?(.find(find + Filter(kind)))
    }

    var body: some View {
        if (
            raindrop.collection != container?.find.collectionId ||
            raindrop.important ||
            !raindrop.highlights.isEmpty ||
            !raindrop.tags.isEmpty
        ) {
            WStack(spacingX: 6, spacingY: 6) {
                //collection
                if raindrop.collection != container?.find.collectionId {
                    DeepLink(.collection(.open(raindrop.collection))) {
                        CollectionLabel(raindrop.collection).badge(0)
                    }
                        .tint(.secondary)
                }
                
                //important
                if raindrop.important {
                    Button { tapFilter(.important) } label: {
                        Image(systemName: Filter.Kind.important.systemImage)
                            .symbolVariant(.fill)
                            .foregroundStyle(.tint)
                    }
                        .tint(Filter.Kind.important.color)
                }
                
                //highlights
                if !raindrop.highlights.isEmpty {
                    Button { tapFilter(.highlights) } label: {
                        Label("\(raindrop.highlights.count)", systemImage: Filter.Kind.highlights.systemImage)
                    }
                        .tint(Filter.Kind.highlights.color)
                        .allowsHitTesting(false)
                }
                
                //tags
                ForEach(raindrop.tags) { tag in
                    Button { tapFilter(.tag(tag)) } label: {
                        Text(tag)
                    }
                }
                    .tint(Filter.Kind.notag.color)
            }
                .buttonStyle(.chip)
                .controlSize(.small)
                .imageScale(.small)
                .padding(.vertical, 4)
                #if canImport(UIKit)
                .disabled(editMode?.wrappedValue == .active)
                #endif
        }
    }
}
