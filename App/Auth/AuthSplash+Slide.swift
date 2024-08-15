import SwiftUI

extension AuthSplash {
    struct Slide<I: View, D: View>: View {
        var title: String
        var colors: [Color]
        var icon: () -> I
        var description: () -> D
        
        var body: some View {
            VStack(spacing: 16) {
                icon()
                    .symbolVariant(.fill)
                    .font(.system(size: 72, weight: .medium))
                    .padding(.bottom, 8)
                    #if !os(visionOS)
                    .foregroundStyle(
                        .linearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    #endif
                
                Text(title)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                description()
                    .font(.title3)
                    .fontWeight(.regular)
                    .imageScale(.small)
                    .symbolVariant(.fill)
                    .foregroundStyle(.secondary)
            }
                .multilineTextAlignment(.center)
                .scenePadding(.horizontal)
                .scenePadding(.horizontal)
        }
    }
}
