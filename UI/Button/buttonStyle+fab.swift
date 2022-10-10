import SwiftUI
import CoreHaptics

public extension ButtonStyle where Self == FabButtonStyle {
    static var fab: Self {
        return .init()
    }
}

public struct FabButtonStyle: ButtonStyle {
    @Environment(\.controlSize) private var controlSize
    
    var size: CGFloat {
        switch controlSize {
        case .large: return 8
        case .regular: return 0
        case .mini, .small: return -4
        @unknown default: return 0
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .foregroundColor(.white)
            .imageScale(.large)
            .frame(minWidth: 56 + size, minHeight: 56 + size)
            .background(.tint)
            .overlay(configuration.isPressed ? Color.black.opacity(0.2) : nil)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .shadow(radius: 30, y: 5)
            #if os(iOS)
            .onChange(of: configuration.isPressed) {
                if $0 {
                    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            #endif
    }
}
