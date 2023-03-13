import SwiftUI

public extension View {
    func listSelectionBehaviour<S: Hashable>(selection: Binding<S?>) -> some View {
        modifier(SingleSelectionModifier(selection: selection))
    }
    
    func listSelectionBehaviour<S: Hashable>(selection: Binding<Set<S>>) -> some View {
        modifier(MultiSelectionModifier(selection: selection))
    }
}

//MARK: - Single
fileprivate struct SingleSelectionModifier<S: Hashable>: ViewModifier {
    @EnvironmentObject private var service: ListBehaviourService<S>
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif

    @Binding var selection: S?
    
    func body(content: Content) -> some View {
        content
            .task(id: selection) {
                if let selection {
                    service.selection = .init([selection])
                } else {
                    service.selection = .init()
                }
            }
            .task(id: service.selection) {
                if let first = service.selection.first {
                    selection = first
                } else {
                    selection = nil
                }
            }
            //reset selection on exit edit
            #if canImport(UIKit)
            .onChange(of: editMode?.wrappedValue) {
                if $0 == .inactive {
                    selection = nil
                }
            }
            #endif
    }
}

//MARK: - Multi
fileprivate struct MultiSelectionModifier<S: Hashable>: ViewModifier {
    @EnvironmentObject private var service: ListBehaviourService<S>
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif

    @Binding var selection: Set<S>

    func body(content: Content) -> some View {
        content
            .task(id: selection) { service.selection = selection }
            .task(id: service.selection) { selection = service.selection }
            //reset selection on exit edit
            #if canImport(UIKit)
            .onChange(of: editMode?.wrappedValue) {
                if $0 == .inactive {
                    selection = .init()
                }
            }
            #endif
    }
}

class ListBehaviourService<S: Hashable>: ObservableObject {
    @Published var selection = Set<S>()
    var primaryAction: ((Set<S>) -> Void)?
    var menu: ((Set<S>) -> AnyView)?
}
