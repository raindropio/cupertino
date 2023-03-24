#if canImport(UIKit)
import SwiftUI

public extension View {
    func safariView(isPresented: Binding<Bool>, url: URL, button: SafariActivityButton? = nil) -> some View {
        sheet(isPresented: isPresented) {
            PlatformSafariView(url: url, button: button)
                .ignoresSafeArea()
        }
    }
    
    func safariView(item: Binding<URL?>, button: SafariActivityButton? = nil) -> some View {
        sheet(item: ItemURL.binding(item)) {
            PlatformSafariView(url: $0.id, button: button)
                .ignoresSafeArea()
        }
    }
}

fileprivate struct ItemURL: Identifiable, Equatable {
    var id: URL
    
    static func binding(_ item: Binding<URL?>) -> Binding<Self?> {
        .init {
            if let url = item.wrappedValue {
                return .init(id: url)
            } else {
                return nil
            }
        } set: {
            item.wrappedValue = $0?.id
        }
    }
}
#endif
