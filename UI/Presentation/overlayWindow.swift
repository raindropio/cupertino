import SwiftUI
import Backport

public extension View {
    /// Special kind of sheet
    @ViewBuilder
    func overlayWindow<C: View>(isPresented: Binding<Bool>, content: @escaping () -> C) -> some View {
        overlay(Window(isPresented: isPresented, content: content))
            .animation(.easeInOut(duration: 0.3), value: isPresented.wrappedValue)
    }
}

fileprivate struct Window<C: View>: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @Binding var isPresented: Bool
    var content: () -> C

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    ._onButtonGesture(pressing: nil) {
                        isPresented = false
                    }
                
                Backport.NavigationStack {
                    content()
                        .backport.scrollContentBackground(.hidden)
                        .presentationBackground(.hidden)
                }
                .presentationBackground(.hidden)
                .background(.regularMaterial)
                .frame(
                    maxWidth: sizeClass == .regular ? 550 : nil,
                    maxHeight: sizeClass == .regular ? 600 : nil
                )
                .modifier(PadSpecific())
                .animation(nil, value: isPresented)
            }
            .transition(.opacity.combined(with: .scale(scale: 1.1)))
        }
    }
}

extension Window {
    fileprivate struct PadSpecific: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass

        func body(content: Content) -> some View {
            if isPhone {
                content
            } else {
                content
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding()
            }
        }
    }
}
