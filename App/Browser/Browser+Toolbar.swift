import SwiftUI
import API
import UI
import Features

extension Browser {
    struct Toolbar {
        @Environment(\.containerHorizontalSizeClass) private var horizontalSizeClass
        @Environment(\.verticalSizeClass) private var verticalSizeClass
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss
        @Environment(\.openURL) private var openURL
        @Environment(\.colorScheme) private var colorScheme

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
        .toolbar(page.prefersHiddenToolbars ? .hidden : .automatic, for: .tabBar, .bottomBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar, .bottomBar)
        .toolbarColorScheme(page.toolbarColorScheme == colorScheme ? nil : page.toolbarColorScheme, for: .navigationBar, .tabBar, .bottomBar)
        //fix transparent navigation bar background
        .overlay(alignment: .top) {
            GeometryReader { geo in
                page.toolbarBackground
                    .frame(height: geo.safeAreaInsets.top)
                    .offset(y: -geo.safeAreaInsets.top)
            }
            .allowsHitTesting(false)
        }
        #endif
        .animation(.default, value: page.prefersHiddenToolbars)
        //buttons
        .toolbar {
            //highlights
            if !raindrop.highlights.isEmpty {
                ToolbarItem {
                    Button { highlights.toggle() } label: {
                        Image(systemName: Filter.Kind.highlights.systemImage)
                            .overlay(alignment: .topTrailing) {
                                NumberInCircle(raindrop.highlights.count)
                                    .offset(x: 11, y: -11)
                            }
                    }
                    .sheet(isPresented: $highlights) {
                        RaindropStack($raindrop, content: RaindropHighlights.init)
                            .frame(idealWidth: 600, idealHeight: 600)
                            #if canImport(AppKit)
                            .fixedSize()
                            #endif
                    }
                }
            }
            
            ToolbarItem {
                if raindrop.isNew, let url = page.url {
                    ShareLink(item: url)
                } else {
                    ShareRaindropLink(raindrop)
                        .equatable()
                }
            }
            
            Group {
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.flexible, placement: placement)
                }
                
                //move
                ToolbarItemGroup(placement: placement) {
                    Button { collection.toggle() } label: {
                        Image(systemName: "folder")
                    }
                        .sheet(isPresented: $collection) {
                            RaindropStack($raindrop, content: RaindropCollection.init)
                                .frame(idealWidth: 600, idealHeight: 600)
                                #if canImport(AppKit)
                                .fixedSize()
                                #endif
                        }
                        .disabled(raindrop.isNew)
                    
                    if #unavailable(iOS 26.0) {
                        Spacer()
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.flexible, placement: placement)
                }
                
                //add tags
                ToolbarItemGroup(placement: placement) {
                    Button { tags.toggle() } label: {
                        Image(systemName: "number")
                            .overlay(alignment: .topTrailing) {
                                NumberInCircle(raindrop.tags.count)
                                    .offset(x: 11, y: -11)
                            }
                    }
                        .sheet(isPresented: $tags) {
                            RaindropStack($raindrop, content: RaindropTags.init)
                                .frame(idealWidth: 600, idealHeight: 600)
                                #if canImport(AppKit)
                                .fixedSize()
                                #endif
                        }
                        .disabled(raindrop.isNew)
                    
                    if #unavailable(iOS 26.0) {
                        Spacer()
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.flexible, placement: placement)
                }
                
                //edit/add
                ToolbarItemGroup(placement: placement) {
                    Button { form.toggle() } label: {
                        Image(systemName: raindrop.isNew ? "plus.circle" : "info.circle")
                    }
                        .sheet(isPresented: $form) {
                            RaindropStack($raindrop, content: RaindropForm.init)
                                #if canImport(AppKit)
                                .frame(idealWidth: 400)
                                .fixedSize()
                                #else
                                .frame(idealWidth: 600, idealHeight: 600)
                                #endif
                        }
                    
                    if #unavailable(iOS 26.0) {
                        Spacer()
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.flexible, placement: placement)
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
                    
                    if #unavailable(iOS 26.0) {
                        Spacer()
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.flexible, placement: placement)
                }
                
                //open
                ToolbarItemGroup(placement: placement) {
                    Button {
                        if let url = page.url {
                            openURL(url)
                        }
                    } label: {
                        Image(systemName: "safari")
                    }
                        .disabled(page.url == nil)
                }
            }
        }
    }
}
