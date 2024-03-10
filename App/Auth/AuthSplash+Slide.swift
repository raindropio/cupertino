import SwiftUI

extension AuthSplash {
    struct Slide<I: View, D: View>: View {
        var title: String
        var colors: [Color]
        var icon: () -> I
        var description: () -> D
        
        var body: some View {
            VStack(spacing: 16) {
                Group {
                    icon()
                        .symbolVariant(.fill)
                        .font(.system(size: 72, weight: .medium))
                        .padding(.bottom, 8)
                    
                    Text(title)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                }
                    #if !os(visionOS)
                    .foregroundStyle(
                        .linearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    #endif
                
                description()
                    .font(.title3)
                    .fontWeight(.regular)
                    .imageScale(.small)
                    .symbolVariant(.fill)
            }
                .multilineTextAlignment(.center)
                .scenePadding(.horizontal)
                .scenePadding(.horizontal)
        }
    }
}
