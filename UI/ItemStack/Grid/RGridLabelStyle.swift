import SwiftUI

struct RGridLabelStyle: LabelStyle {
    @ScaledMetric private var gap = ItemStackConstants.gap
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.icon
                .aspectRatio(1.333, contentMode: .fit)
            
            configuration.title
                .padding(gap)
                .labelStyle(.automatic)
        }
    }
}
