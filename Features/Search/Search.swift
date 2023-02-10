import SwiftUI
import API
import UI

public struct Search<C: View>: View {
    @State private var refine: FindBy = .init()
    @State private var isActive = false

    var base: FindBy
    var content: (FindBy, Bool) -> C
    
    public init(_ base: FindBy, content: @escaping (_ refine: FindBy, _ isActive: Bool) -> C) {
        self.base = base
        self.content = content
    }
    
    public var body: some View {
        content(
            isActive ? refine : base,
            isActive
        )
            .onSearching {
                if isActive != $0 {
                    refine = $0 ? base : .init()
                    isActive = $0
                }
            }
            .onChange(of: refine) {
                if $0.isSearching, !isActive {
                    refine = refine + base
                    isActive = true
                }
            }
            .modifier(Animations(refine: $refine, isActive: isActive))
            .modifier(Bar(refine: $refine))
            .modifier(Scope(base: base, refine: $refine, isActive: isActive))
            .modifier(Loading(refine: $refine, isActive: isActive))
    }
}
