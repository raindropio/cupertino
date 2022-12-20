import SwiftUI
import Backport

extension AuthSplash {
    struct Slide<I: View, D: View>: View {
        @State private var anim = true
        
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
                        .backport.fontWeight(.bold)
                        .font(.largeTitle)
                }
                    .foregroundStyle(
                        .linearGradient(
                            colors: colors,
                            startPoint: anim ? .topLeading : .bottomTrailing,
                            endPoint: anim ? .bottomTrailing : .topTrailing
                        )
                    )
                    .hueRotation(.degrees(anim ? -30 : 30))
                    .animation(.easeInOut(duration: 3).repeatForever(), value: anim)
                    .onAppear { anim = false }
                    .onDisappear { anim = true }
                
                description()
                    .font(.title3)
                    .imageScale(.small)
                    .symbolVariant(.fill)
            }
                .multilineTextAlignment(.center)
                .scenePadding([.horizontal, .bottom])
                .offset(y: -32)
                .frame(maxWidth: 500)
        }
    }
}
