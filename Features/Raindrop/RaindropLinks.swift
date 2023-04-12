import SwiftUI
import API
import UI

struct RaindropLinks: View {
    @Environment(\.openDeepLink) private var openDeepLink
    @Environment(\.raindropsContainer) private var container
    @IsEditing private var isEditing

    var raindrop: Raindrop
    
    private func tapFilter(_ kind: Filter.Kind) {
        guard let find = container?.find else { return }
        openDeepLink?(.find(find + Filter(kind)))
    }

    var body: some View {
        if (
            raindrop.collection != container?.find.collectionId ||
            raindrop.important ||
            raindrop.reminder != nil ||
            !raindrop.highlights.isEmpty ||
            !raindrop.tags.isEmpty
        ) {
            WStack(spacingX: 6, spacingY: 6) {
                //collection
                if raindrop.collection != container?.find.collectionId {
                    DeepLink(.collection(.open(raindrop.collection))) {
                        CollectionLabel(raindrop.collection).badge(0)
                    }
                        .tint(.gray)
                }
                
                //important
                if raindrop.important {
                    Button { tapFilter(.important) } label: {
                        Image(systemName: Filter.Kind.important.systemImage)
                            .foregroundStyle(.tint)
                    }
                        .tint(Filter.Kind.important.color)
                }
                
                //reminder
                if let date = raindrop.reminder?.date {
                    Button {} label: {
                        Label {
                            Text(date, formatter: .shortDateTime)
                        } icon: {
                            Image(systemName: Filter.Kind.reminder.systemImage)
                        }
                    }
                        .tint(Filter.Kind.reminder.color)
                        .allowsHitTesting(false)
                }
                
                //highlights
                if !raindrop.highlights.isEmpty {
                    Button {} label: {
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
                .symbolVariant(.fill)
                .padding(.vertical, 4)
                .disabled(isEditing)
        }
    }
}
