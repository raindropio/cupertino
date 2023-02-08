import SwiftUI
import API
import UI
import Features

extension Browser {
    struct Toolbar {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        @Environment(\.verticalSizeClass) private var verticalSizeClass
        
        @State private var appearance = false
        @State private var collection = false
        @State private var tags = false
        @State private var highlights = false
        @State private var form = false

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
                Button { collection.toggle() } label: {
                    Image(systemName: "folder")
                }
                    .popover(isPresented: $collection) {
                        RaindropStack($raindrop, content: RaindropCollection.init)
                            .frame(idealWidth: 400, idealHeight: 600)
                    }
                    .disabled(raindrop.isNew)
                Spacer()
            }
            
            //add tags
            ToolbarItemGroup(placement: placement) {
                Button { tags.toggle() } label: {
                    Image(systemName: "number")
                        .overlay(alignment: .topTrailing) {
                            if !raindrop.tags.isEmpty {
                                Text(raindrop.tags.count, format: .number)
                                    .circularBadge()
                                    .offset(x: 10, y: -10)
                            }
                        }
                }
                    .popover(isPresented: $tags) {
                        RaindropStack($raindrop, content: RaindropTags.init)
                            .frame(idealWidth: 400, idealHeight: 600)
                    }
                    .disabled(raindrop.isNew)
                Spacer()
            }
            
            //highlights
            ToolbarItemGroup(placement: placement) {
                Button { highlights.toggle() } label: {
                    Image(systemName: Filter.Kind.highlights.systemImage)
                        .overlay(alignment: .topTrailing) {
                            if !raindrop.highlights.isEmpty {
                                Text(raindrop.highlights.count, format: .number)
                                    .circularBadge()
                                    .offset(x: 10, y: -10)
                            }
                        }
                }
                    .popover(isPresented: $highlights) {
                        RaindropStack($raindrop, content: RaindropHighlights.init)
                            .frame(idealWidth: 400, idealHeight: 600)
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
                Button { form.toggle() } label: {
                    Image(systemName: raindrop.isNew ? "plus.circle" : "ellipsis.circle")
                }
                .popover(isPresented: $form) {
                    RaindropStack($raindrop, content: RaindropForm.init)
                        .frame(idealWidth: 400, idealHeight: 600)
                }
            }
        }
    }
}
