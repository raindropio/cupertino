import SwiftUI

public extension View {
    func fab<B>(@ViewBuilder _ buttons: @escaping () -> B) -> some View where B: View {
        modifier(Fab(buttons: buttons))
    }
}

fileprivate struct Fab<B: View>: ViewModifier {
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    var buttons: () -> B
    
    func body(content: Content) -> some View {
        #if canImport(UIKit)
        let hide = editMode?.wrappedValue == .active
        #else
        let hide = false
        #endif
        
        content
//            ._safeAreaInsets(.init(top: 0, leading: 0, bottom: 60, trailing: 0))
            .overlay(alignment: .bottomTrailing) {
                buttons()
                    .buttonStyle(.fab)
                    .opacity(hide ? 0 : 1)
                    .scaleEffect(hide ? 0 : 1)
                    .padding(.trailing, 20)
                    .ignoresSafeArea(.keyboard)
            }
    }
}
