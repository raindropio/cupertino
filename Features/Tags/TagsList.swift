import SwiftUI
import Backport
import API
import UI

public struct TagsList {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var f: FiltersStore
    @State private var new = ""
    @FocusState private var focused: Bool

    @Binding var value: [String]
    
    public init(_ value: Binding<[String]>) {
        self._value = value
    }
}

extension TagsList {
    private func add(_ tag: String) {
        guard !tag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }
        value.append(tag)
        new = ""
    }
    
    private func delete(_ tag: String) {
        value = value.filter { $0 != tag }
    }
    
    private var selected: [String] {
        value
            .filter {
                if !new.isEmpty {
                    return $0.similiar(to: new)
                }
                return true
            }
    }
    
    private var suggestions: [Filter] {
        f.state.tags()
            .filter {
                switch $0.kind {
                case .tag(let tag):
                    if value.contains(tag) {
                        return false
                    }
                    if !new.isEmpty {
                        return tag.similiar(to: new)
                    }
                    return true
                default:
                    return false
                }
            }
    }
}

extension TagsList: View {
    public var body: some View {
        List {
            Section {
                //selected
                ForEach(selected, id: \.self) { tag in
                    Button { delete(tag) } label: {
                        Label {
                            Text(tag).foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                //new
                Label {
                    TextField("Add tag", text: $new)
                        .focused($focused)
                        #if canImport(UIKit)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.webSearch)
                        #endif
                } icon: {
                    Button { focused = true } label: {
                        Image(systemName: "plus")
                    }
                        .tint(.gray)
                }
                    .onSubmit(of: .text) {
                        focused = !new.isEmpty
                        add(new)
                    }
            }
            
            //suggestions
            Section {
                ForEach(suggestions, id: \.title) { filter in
                    Button { add(filter.title) } label: {
                        Text(filter.title).foregroundColor(.primary)
                    }
                        .swipeActions { TagsMenu(filter) }
                        .badge(filter.count)
                }
            } header: {
                if !suggestions.isEmpty {
                    Text("Other")
                }
            }
        }
            .animation(.default, value: selected)
            .animation(.default, value: suggestions)
            .tagEvents()
            .reload {
                try? await dispatch(
                    FiltersAction.reload(),
                    RecentAction.reload()
                )
            }
    }
}

fileprivate extension String {
    func similiar(to: String) -> Bool {
        localizedLowercase.contains(
            to.localizedLowercase.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
