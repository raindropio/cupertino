import SwiftUI

extension View {
    func withSheetPresentationController(
        _ sheetPresentationController: Binding<UISheetPresentationController?>,
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil
    ) -> some View {
        overlay {
            WithSheetPresentationController(
                sheetPresentationController: sheetPresentationController,
                onAppear: onAppear,
                onDisappear: onDisappear
            )
                .opacity(0)
        }
    }
}

fileprivate struct WithSheetPresentationController: UIViewControllerRepresentable {
    @Binding var sheetPresentationController: UISheetPresentationController?
    var onAppear: (() -> Void)?
    var onDisappear: (() -> Void)?
    
    func makeUIViewController(context: Context) -> VC {
        VC {
            sheetPresentationController = $0
        } onDidAppear: { _ in
            onAppear?()
        } onDisappear: { _ in
            onDisappear?()
        }
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
    
    class VC: UIViewController {
        var onWillAppear: (UISheetPresentationController?) -> Void
        var onDidAppear: (UISheetPresentationController?) -> Void
        var onWillDisappear: (UISheetPresentationController?) -> Void
        
        init(
            onWillAppear: @escaping (UISheetPresentationController?) -> Void,
            onDidAppear: @escaping (UISheetPresentationController?) -> Void,
            onDisappear: @escaping (UISheetPresentationController?) -> Void
        ) {
            self.onWillAppear = onWillAppear
            self.onDidAppear = onDidAppear
            self.onWillDisappear = onDisappear
            super.init(nibName: nil, bundle: nil)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear(sheetPresentationController)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            onDidAppear(sheetPresentationController)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear(sheetPresentationController)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
