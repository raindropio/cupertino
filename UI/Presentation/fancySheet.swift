import SwiftUI
import Backport

public extension View {
    /// Special kind of sheet
    @ViewBuilder
    func fancySheet<C: View>(isPresented: Binding<Bool>, content: @escaping () -> C) -> some View {
        fullScreenCover(isPresented: isPresented) {
            FancySheet(content: content)
                .transaction { $0.disablesAnimations = false }
                .overlay(PresentationFadeOut().opacity(0))
        }
        //disable native modal appear animation
        .transaction {
            if isPresented.wrappedValue {
                $0.disablesAnimations = true
            }
        }
    }
}

fileprivate struct FancySheet<C: View>: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dismiss) private var dismiss
    @State private var isAppeared = false
    var content: () -> C

    var body: some View {
        ZStack {
            Color.black.opacity(0.15)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                ._onButtonGesture(pressing: nil, perform: dismiss.callAsFunction)
            
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
                .animation(nil, value: isAppeared)
                .blur(radius: sizeClass == .compact || isAppeared ? 0 : 10)
                .scaleEffect(sizeClass == .compact || isAppeared ? 1 : 1.1)
        }
            .opacity(isAppeared ? 1 : 0)
            .animation(.easeOut(duration: 0.2), value: isAppeared)
            .onAppear { isAppeared = true }
    }
}

extension FancySheet {
    fileprivate struct PadSpecific: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass

        func body(content: Content) -> some View {
            if isPhone {
                content
            } else {
                content
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(.tertiary.opacity(0.3), lineWidth: 1)
                    )
                    .padding()
            }
        }
    }
}

fileprivate struct PresentationFadeOut: UIViewControllerRepresentable {
    class VC: UIViewController {
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            parent?.modalTransitionStyle = .crossDissolve
        }
    }
    
    func makeUIViewController(context: Context) -> VC { .init()}
    func updateUIViewController(_ controller: VC, context: Context) {}
}
