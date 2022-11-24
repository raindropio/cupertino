import SwiftUI

public extension View {
    func fab<B: View>(hide: Bool = false, @ViewBuilder _ buttons: @escaping () -> B) -> some View {
        modifier(Fab(hide: hide, buttons: buttons))
    }
    
    func fab<B: View>(hide: Bool = false, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> B) -> some View {
        modifier(Fab(hide: hide) {
            Button(action: action, label: label)
        })
    }
}

fileprivate struct Fab<B: View>: ViewModifier {
    var hide: Bool
    var buttons: () -> B
    
    func body(content: Content) -> some View {
        content
//            ._safeAreaInsets(.init(top: 0, leading: 0, bottom: 60, trailing: 0))
            .overlay(alignment: .bottomTrailing) {
                buttons()
                    .buttonStyle(.fab)
                    .menuStyle(.fab)
                    .opacity(hide ? 0 : 1)
                    .scaleEffect(hide ? 0 : 1)
                    .padding(.trailing, 20)
                    .ignoresSafeArea(.keyboard)
            }
    }
}
