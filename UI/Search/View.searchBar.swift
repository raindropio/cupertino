import SwiftUI

public extension View {
    func searchBar(
        withToolbar: Bool? = nil,
        cancelable: Bool? = nil,
        clearable: Bool? = nil,
        tokenBackgroundColor: Color? = nil
    ) -> some View {
        modifier(SearchBarModifier(
            withToolbar: withToolbar,
            cancelable: cancelable,
            clearable: clearable,
            tokenBackgroundColor: tokenBackgroundColor
        ))
    }
}

fileprivate struct SearchBarModifier: ViewModifier {
    var withToolbar: Bool?
    var cancelable: Bool?
    var clearable: Bool?
    var tokenBackgroundColor: Color? = nil
    
    @State private var controller: UISearchController?
    
    func body(content: Content) -> some View {
        content
            .withSearchController($controller) {}
                onDisappear: {
                    //otherwise buggy
                    if let withToolbar, withToolbar {
                        controller?.isActive = false
                    }
                }
            .onChange(of: controller) {
                if let withToolbar {
                    $0?.hidesNavigationBarDuringPresentation = !withToolbar
                }
                if let cancelable {
                    $0?.automaticallyShowsCancelButton = cancelable
                }
                if let clearable {
                    $0?.searchBar.searchTextField.clearButtonMode = clearable ? .always : .never
                }
                if let tokenBackgroundColor {
                    $0?.searchBar.searchTextField.tokenBackgroundColor = UIColor(tokenBackgroundColor)
                }
            }
            .onChange(of: withToolbar) {
                if let withToolbar = $0 {
                    controller?.hidesNavigationBarDuringPresentation = !withToolbar
                }
            }
            .onChange(of: cancelable) {
                if let cancelable = $0 {
                    controller?.automaticallyShowsCancelButton = cancelable
                }
            }
            .onChange(of: clearable) {
                if let clearable = $0 {
                    controller?.searchBar.searchTextField.clearButtonMode = clearable ? .always : .never
                }
            }
            .onChange(of: tokenBackgroundColor) {
                if let tokenBackgroundColor = $0 {
                    controller?.searchBar.searchTextField.tokenBackgroundColor = UIColor(tokenBackgroundColor)
                }
            }
    }
}

