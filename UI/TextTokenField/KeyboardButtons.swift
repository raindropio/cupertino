import SwiftUI
import Backport

#if canImport(UIKit)
class KeyboardButtons: UIInputView {
    private var hosting: UIHostingController<Hosting>
    
    init(_ items: [String], onPress: @escaping (String) -> Void) {
        //init
        self.hosting = .init(rootView: .init(items: items, onPress: onPress))
        super.init(frame: .init(x: 0, y: 0, width: 100, height: 50), inputViewStyle: .keyboard)
        
        //subview
        hosting.view.backgroundColor = .clear
        addSubview(hosting.view)
        
        //constraints
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hosting.view.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    func update(_ items: [String]) {
        if hosting.rootView.items != items {
            hosting.rootView = .init(items: items, onPress: hosting.rootView.onPress)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KeyboardButtons {
    private struct Hosting: View {
        @Environment(\.hapticFeedback) private var hapticFeedback
        @Environment(\.horizontalSizeClass) private var sizeClass
        
        var items: [String] = []
        var onPress: (String) -> Void
                
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 6) {
                    ForEach(items, id: \.self) { item in
                        if item.isEmpty {
                            Rectangle().fill(.quaternary)
                                .frame(width: 1)
                                .padding(6)
                        } else {
                            Button(item) {
                                onPress(item)
                                hapticFeedback(.rigid)
                            }
                        }
                    }
                    .transition(.scale(scale: 0).combined(with: .opacity))
                }
                    .backport.scrollBounceBehavior(.basedOnSize, axes: [.horizontal, .vertical])
                    .buttonStyle(KeyboardButtonStyle())
                    .padding(.vertical, sizeClass == .regular ? 12 : 8)
                    .padding(.horizontal, sizeClass == .regular ? 14 : 8)
            }
            .animation(.spring(), value: items.count)
        }
    }
}

fileprivate struct KeyboardButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(.white)
                    .opacity(colorScheme == .dark ? (configuration.isPressed ? 0.1 : 0.3) : (configuration.isPressed ? 0.5 : 1))
                    .shadow(color: .black.opacity(colorScheme == .dark ? 1 : 0.3), radius: 0, y: 1)
                    .animation(nil, value: configuration.isPressed)
            )
            .foregroundColor(.primary)
            .padding(.bottom, 1)
    }
}
#endif
