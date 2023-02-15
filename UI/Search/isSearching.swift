import SwiftUI

public extension View {
    func isSearching(_ condition: Binding<Bool>) -> some View {
        overlay(Update(condition: condition.wrappedValue).opacity(0))
            .modifier(OnChange(condition: condition))
    }
}

fileprivate struct OnChange: ViewModifier {
    @Environment(\.isSearching) private var isSearching
    @Binding var condition: Bool
    
    func body(content: Content) -> some View {        
        content
            .onAppear { condition = isSearching }
            .onChange(of: isSearching) {
                condition = $0
            }
    }
}

fileprivate struct Update: UIViewControllerRepresentable {
    var condition: Bool
    
    func makeUIViewController(context: Context) -> VC {
        .init(self)
    }

    func updateUIViewController(_ controller: VC, context: Context) {
        controller.update(self)
    }
    
    class VC: UIViewController {
        var base: Update
        
        init(_ base: Update) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @MainActor
        func update(_ base: Update) {
            self.base = base
            
            guard let searchController = parent?.navigationItem.searchController else { return }
            guard searchController.searchBar.isFirstResponder != base.condition else { return }
            
            if base.condition {
                searchController.searchBar.becomeFirstResponder()
                searchController.isActive = true
            } else {
                searchController.searchBar.resignFirstResponder()
                searchController.isActive = false
            }
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(base)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            update(base)
        }
    }
}
