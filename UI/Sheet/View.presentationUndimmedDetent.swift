import SwiftUI

public extension View {
    func presentationUndimmedDetent(_ identifier: UISheetPresentationController.Detent.Identifier?) -> some View {
        modifier(PresentationUndimmedDetentModifier(identifier: identifier))
    }
}

fileprivate struct PresentationUndimmedDetentModifier: ViewModifier {
    var identifier: UISheetPresentationController.Detent.Identifier?
    @State private var controller: UISheetPresentationController?

    func body(content: Content) -> some View {
        content
            .withSheetPresentationController($controller)
            .onChange(of: controller) {
                $0?.largestUndimmedDetentIdentifier = identifier
            }
            .onChange(of: identifier) {
                controller?.largestUndimmedDetentIdentifier = $0
            }
    }
}
