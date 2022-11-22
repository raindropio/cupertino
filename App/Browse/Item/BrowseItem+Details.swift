import SwiftUI
import API
import UI

extension BrowseItem {
    struct Details: View {
        var raindrop: Raindrop
        var vertical = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(raindrop.title)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                
                if !raindrop.excerpt.isEmpty {
                    Text(raindrop.excerpt)
                        .lineLimit(3)
                }
                
                Buttons(raindrop: raindrop)
                
                if vertical {
                    Spacer(minLength: 0)
                }
                
                (
                    (
                        raindrop.type != .link ?
                            Text(Image(systemName: raindrop.type.systemImage)) + Text("\u{00a0}") :
                            Text("")
                    )
                    + Text(raindrop.link.host ?? "")
                    + Text("\u{00a0}• ")
                    + Text(raindrop.created, formatter: .shortDateTime)
                )
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .symbolVariant(.fill)
                    .imageScale(.small)
            }
                .frame(maxHeight: .infinity)
                .padding(vertical ? 12 : 0)
        }
    }
}
