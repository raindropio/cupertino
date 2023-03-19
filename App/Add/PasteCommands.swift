import SwiftUI
import API
import UI
import Features

extension View {
    func pasteCommands(enabled: Bool = true, to collection: Int = -1) -> some View {
        modifier(AB(enabled: enabled, collection: collection))
    }
}

fileprivate struct AB: ViewModifier {
    @IsEditing private var isEditing
    @Environment(\.drop) private var drop
    #if canImport(UIKit)
    @Environment(\.isSearching) private var isSearching
    #endif
    
    var enabled: Bool
    var collection: Int
    
    private func add(_ items: [NSItemProvider]) {
        drop?(items, collection)
    }
    
    func body(content: Content) -> some View {
        let types = enabled ? addTypes.filter { $0 != .text } : []
        
        content
            #if canImport(UIKit)
            .overlay(alignment: .bottomTrailing) {
                if collection != -99, !isEditing, !isSearching {
                    OptionalPasteButton(
                        supportedContentTypes: types,
                        payloadAction: add
                    )
                        .circlePasteButton()
                        .transition(.opacity)
                        .padding(.horizontal, 20)
                        .ignoresSafeArea(.keyboard)
                }
            }
            #else
            .onPasteCommand(of: types, perform: add)
            .importsItemProviders(types) { add($0); return true }
            #endif
    }
}
