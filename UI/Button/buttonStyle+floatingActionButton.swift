import SwiftUI
import CoreHaptics
import Backport

public extension ButtonStyle where Self == FabButtonStyle {
    static var floatingActionButton: Self {
        return .init()
    }
}

public extension MenuStyle where Self == FabMenuButtonStyle {
    static var floatingActionButton: Self {
        return .init()
    }
}

fileprivate struct FabStyleModifier: ViewModifier {
    @Environment(\.controlSize) private var controlSize
    
    var isPressed = false
    
    private var size: Double {
        switch controlSize {
        case .large: return 8
        case .regular: return 0
        case .mini, .small: return -4
        @unknown default: return 0
        }
    }
    
    func body(content: Content) -> some View {
        content
            .backport.fontWeight(.semibold)
            .foregroundColor(.white)
            .imageScale(.large)
            .frame(width: 56 + size, height: 56 + size)
            .background(.tint)
            .overlay(isPressed ? Color.black.opacity(0.2) : nil)
            .clipShape(Circle())
            .scaleEffect(isPressed ? 0.8 : 1)
            .shadow(radius: 30, y: 5)
            .contentShape(Circle())
            #if os(iOS)
            .onChange(of: isPressed) {
                if $0 {
                    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            #endif
    }
}

public struct FabButtonStyle: ButtonStyle {
    @Environment(\.controlSize) private var controlSize
    
    var size: Double {
        switch controlSize {
        case .large: return 8
        case .regular: return 0
        case .mini, .small: return -4
        @unknown default: return 0
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(FabStyleModifier(isPressed: configuration.isPressed))
    }
}

public struct FabMenuButtonStyle: MenuStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .modifier(FabStyleModifier())
    }
}
