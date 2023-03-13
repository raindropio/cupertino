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
                    .foregroundStyle(
                        .linearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                description()
                    .font(.title3)
                    .imageScale(.small)
                    .symbolVariant(.fill)
            }
                .multilineTextAlignment(.center)
                .scenePadding([.horizontal, .bottom])
                .offset(y: -32)
                .transition(.identity)
        }
    }
}
