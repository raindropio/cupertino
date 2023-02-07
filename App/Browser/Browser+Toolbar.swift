import SwiftUI
import API
import UI

extension Browser {
    struct Toolbar {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        @Environment(\.verticalSizeClass) private var verticalSizeClass
        @State private var appearance = false
        
        @ObservedObject var page: WebPage
        @Binding var raindrop: Raindrop
    }
}

extension Browser.Toolbar {
    private var mode: Browse.Location.Mode {
        page.request?.attribute as? Browse.Location.Mode ?? .raw
    }
    
    private var portrait: Bool {
        verticalSizeClass == .regular && horizontalSizeClass == .compact
    }
            
    private var placement: ToolbarItemPlacement {
        portrait ? .bottomBar : .automatic
    }
}

extension Browser.Toolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
        //overall
        .toolbarRole(.editor)
        .toolbar(page.prefersHiddenToolbars ? .hidden : .automatic, for: .navigationBar, .tabBar, .bottomBar)
        .animation(.default, value: page.prefersHiddenToolbars)
        //buttons
        .toolbar {
            //reader
            ToolbarItemGroup {
                if mode == .article {
                    Button { appearance.toggle() } label: {
                        Image(systemName: "textformat.size")
                    }
                        .popover(isPresented: $appearance, content: ReaderAppearance.init)
                    
                    Spacer()
                }
            }
            
            //share
            ToolbarItemGroup {
                ShareLink(item: page.url ?? .init(string: "about:blank")!)
                    .disabled(page.url == nil)
                Spacer()
            }
            
            //move
            ToolbarItemGroup(placement: placement) {
                Button {
                    
                } label: {
                    Image(systemName: "folder")
                }
                    .disabled(raindrop.isNew)
                Spacer()
            }
            
            //add tags
            ToolbarItemGroup(placement: placement) {
                Button {
                    
                } label: {
                    Image(systemName: "number")
                }
                    .disabled(raindrop.isNew)
                Spacer()
            }
            
            //highlights
            ToolbarItemGroup(placement: placement) {
                Button {
                    
                } label: {
                    Image(systemName: Filter.Kind.highlights.systemImage)
                        .overlay(alignment: .topTrailing) {
                            if !raindrop.highlights.isEmpty {
                                Text(raindrop.highlights.count, format: .number)
                                    .circularBadge()
                                    .offset(x: 10, y: -10)
                            }
                        }
                }
                    .disabled(raindrop.isNew)
                Spacer()
            }
            
            //safari
            ToolbarItemGroup(placement: placement) {
                Link(destination: page.url ?? .init(string: "about:blank")!) {
                    Image(systemName: "safari")
                }
                    .disabled(page.url == nil)
                Spacer()
            }
            
            //edit/add
            ToolbarItemGroup(placement: placement) {
                Button {
                    
                } label: {
                    Image(systemName: raindrop.isNew ? "plus.circle" : "ellipsis.circle")
                }
            }
        }
    }
}
