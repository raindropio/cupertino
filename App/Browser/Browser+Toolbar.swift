import SwiftUI
import API
import UI
import Features

extension Browser {
    struct Toolbar {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        @Environment(\.verticalSizeClass) private var verticalSizeClass
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss

        @State private var collection = false
        @State private var tags = false
        @State private var highlights = false
        @State private var form = false

        @ObservedObject var page: WebPage
        @Binding var raindrop: Raindrop
    }
}

extension Browser.Toolbar {
    private var portrait: Bool {
        verticalSizeClass == .regular && horizontalSizeClass == .compact
    }
            
    private var placement: ToolbarItemPlacement {
        #if canImport(UIKit)
        portrait ? .bottomBar : .automatic
        #else
        .automatic
        #endif
    }
}

extension Browser.Toolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
        //overall
        .toolbarRole(.editor)
        #if canImport(UIKit)
        .toolbar(page.prefersHiddenToolbars ? .hidden : .automatic, for: .navigationBar, .tabBar, .bottomBar)
        #endif
        .animation(.default, value: page.prefersHiddenToolbars)
        //buttons
        .toolbar {
            ToolbarTitleMenu {
                if let url = page.url {
                    Link(destination: url) {
                        Label("Open in browser", systemImage: "arrow.up.forward")
                    }
                }
            }
            
            //highlights
            ToolbarItemGroup {
                Button { highlights.toggle() } label: {
                    Image(systemName: Filter.Kind.highlights.systemImage)
                        .overlay(alignment: .topTrailing) {
                            if !raindrop.highlights.isEmpty {
                                Text(raindrop.highlights.count, format: .number)
                                    .circularBadge()
                                    .offset(x: 11, y: -11)
                            }
                        }
                }
                    .popover(isPresented: $highlights) {
                        RaindropStack($raindrop, content: RaindropHighlights.init)
                            .frame(idealWidth: 400, idealHeight: 600)
                    }
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
                                    .offset(x: 11, y: -11)
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
            
            //edit/add
            ToolbarItemGroup(placement: placement) {
                Button { form.toggle() } label: {
                    Image(systemName: raindrop.isNew ? "plus.circle" : "info.circle")
                }
                    .popover(isPresented: $form) {
                        RaindropStack($raindrop, content: RaindropForm.init)
                            .frame(idealWidth: 400, idealHeight: 600)
                    }
                Spacer()
            }
            
            //share
            ToolbarItemGroup(placement: placement) {
                ShareLink(item: page.url ?? .init(string: "about:blank")!)
                    .disabled(page.url == nil)
                Spacer()
            }
            
            //delete
            ToolbarItemGroup(placement: placement) {
                ActionButton {
                    try await dispatch(RaindropsAction.delete(raindrop.id))
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                }
                    .disabled(raindrop.isNew)
            }
        }
    }
}
