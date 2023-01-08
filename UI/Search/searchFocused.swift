import SwiftUI

public extension View {
    func searchFocused(_ condition: Binding<Bool>) -> some View {
        overlay {
            FocusSearchController(condition: condition.wrappedValue)
                .opacity(0)
        }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) {
                if $0.object is UISearchTextField {
                    condition.wrappedValue = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) {
                if $0.object is UISearchTextField {
                    condition.wrappedValue = false
                }
            }
    }
}

fileprivate struct FocusSearchController: UIViewControllerRepresentable {
    var condition: Bool
    
    func makeUIViewController(context: Context) -> VC {
        .init(self)
    }

    func updateUIViewController(_ controller: VC, context: Context) {
        controller.update(self)
    }
}

extension FocusSearchController {
    class VC: UIViewController {
        var base: FocusSearchController
        var animate = false
        
        init(_ base: FocusSearchController) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @MainActor
        func update(_ base: FocusSearchController) {
            self.base = base
            
            guard let searchBar = parent?.navigationItem.searchController?.searchBar else { return }
            guard searchBar.isFirstResponder != base.condition else { return }
            
            if base.condition {
                let animate = animate
                Task { [weak searchBar] in
                    if animate {
                        searchBar?.becomeFirstResponder()
                    } else {
                        UIView.performWithoutAnimation {
                            searchBar?.becomeFirstResponder()
                        }
                    }
                }
            } else {
                searchBar.resignFirstResponder()
            }
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(base)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            update(base)
            animate = true
        }
    }
}
