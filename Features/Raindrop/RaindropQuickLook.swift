import SwiftUI
import API
import QuickLook

struct RaindropQuickLook: ViewModifier {
    @Binding var selection: Set<Raindrop>
    @State private var show = false

    func body(content: Content) -> some View {
        content
            #if os(macOS)
            .onCommand(#selector(NSResponder.indent(_:))) {
                show = true
            }
            #endif
            .quickLookPreview(.init(get: {
                show ? selection.first?.link : nil
            }, set: {
                if $0 == nil {
                    show = false
                }
            }))
    }
}
