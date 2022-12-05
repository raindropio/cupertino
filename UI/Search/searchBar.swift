import SwiftUI
import Combine

#if canImport(UIKit)
public extension View {
    func searchBar(
        withToolbar: Bool? = nil,
        withButton: Bool? = nil,
        cancelable: Bool? = nil,
        clearable: Bool? = nil,
        autoReturnKey: Bool? = nil,
        scopeBarActivation: ScopeBarActivation = .automatic,
        tokenBackgroundColor: Color? = nil
    ) -> some View {
        modifier(SearchBarModifier(
            withToolbar: withToolbar,
            withButton: withButton,
            cancelable: cancelable,
            clearable: clearable,
            autoReturnKey: autoReturnKey,
            scopeBarActivation: scopeBarActivation,
            tokenBackgroundColor: tokenBackgroundColor
        ))
    }
}

fileprivate struct SearchBarModifier: ViewModifier {
    var withToolbar: Bool?
    var withButton: Bool?
    var cancelable: Bool?
    var clearable: Bool?
    var autoReturnKey: Bool?
    var scopeBarActivation: ScopeBarActivation
    var tokenBackgroundColor: Color? = nil
    
    @Environment(\.editMode) private var editMode
    @State private var controller: UISearchController?
    @State private var showToolbarButton = true
    
    func body(content: Content) -> some View {
        content
            .withSearchController($controller) {}
                onDisappear: {
                    //otherwise buggy
                    if let withToolbar, withToolbar {
                        controller?.isActive = false
//                        controller?.searchBar.resignFirstResponder()
                    }
                }
                onVisibilityChange: {
                    showToolbarButton = (withButton == true) && !$0
                }
            .toolbar {
                ToolbarItem {
                    SearchButton(controller: $controller)
                        .opacity(
                            (editMode?.wrappedValue != .active) &&
                            showToolbarButton ? 1 : 0
                        )
                }
            }
            .onChange(of: controller) {
                if #available(iOS 16.0, *) {
                    $0?.scopeBarActivation = scopeBarActivation.uiKit()
                }
                   
                if let withToolbar {
                    $0?.hidesNavigationBarDuringPresentation = !withToolbar
                }
                if let cancelable {
                    $0?.automaticallyShowsCancelButton = cancelable
                }
                if let clearable {
                    $0?.searchBar.searchTextField.clearButtonMode = clearable ? .always : .never
                }
                if let autoReturnKey {
                    $0?.searchBar.searchTextField.enablesReturnKeyAutomatically = autoReturnKey
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
            .onChange(of: autoReturnKey) {
                if let autoReturnKey = $0 {
                    controller?.searchBar.searchTextField.enablesReturnKeyAutomatically = autoReturnKey
                }
            }
            .onChange(of: scopeBarActivation) {
                if #available(iOS 16.0, *) {
                    controller?.scopeBarActivation = $0.uiKit()
                }
            }
            .onChange(of: tokenBackgroundColor) {
                if let tokenBackgroundColor = $0 {
                    controller?.searchBar.searchTextField.tokenBackgroundColor = UIColor(tokenBackgroundColor)
                }
            }
    }
}

public enum ScopeBarActivation: Int {
    case automatic = 0
    case manual = 1
    case onTextEntry = 2
    case onSearchActivation = 3
    
    @available(iOS 16.0, *)
    func uiKit() -> UISearchController.ScopeBarActivation {
        switch self {
        case .automatic: return .automatic
        case .manual: return .manual
        case .onTextEntry: return .onTextEntry
        case .onSearchActivation: return .onSearchActivation
        }
    }
}
#endif
