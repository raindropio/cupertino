#if os(iOS)
import SwiftUI
import SwiftUIX

struct PlatformTokenField: View {
    var title: String = ""
    @Binding public var value: [String]
    var prompt: String
    var suggestions: [String]
    
    @Environment(\.autocorrectionDisabled) private var autocorrectionDisabled
    
    var body: some View {
        NavigationLink {
            TokenFieldPicker(title: title, value: $value, prompt: prompt, suggestions: suggestions)
                .environment(\.autocorrectionDisabled, autocorrectionDisabled)
        } label: {
            Label(value.isEmpty ? title : value.joined(separator: ", "), systemImage: "number")
        }
    }
}

struct TokenFieldPicker: View {
    var title: String = ""
    @Binding public var value: [String]
    var prompt: String
    var suggestions: [String]
    
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""
    @FocusState private var searching: Bool
    
    func add(_ text: String) {
        value = value + text
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    func remove(_ text: String) {
        value = value.filter { $0 != text }
    }
    
    var body: some View {
        let all = TokenFieldUtils.filter(value, value: suggestions, by: search) + TokenFieldUtils.filter(suggestions, value: [], by: search)
        
        List {
            Section {
                SearchField(search: $search, prompt: prompt)
                    .focused($searching)
            }
            
            Section {
                ForEach(all, id:\.self) {
                    let selected = value.contains($0)
                    
                    ItemView(
                        text: $0,
                        selected: selected,
                        onTap: selected ? remove : add
                    )
                }
                
                if all.isEmpty, !search.isEmpty {
                    CreateItem(text: search, onTap: add)
                }
            }
        }
            //appearance
            .navigationTitle(value.isEmpty ? title : "Selected \(value.count)")
            //default focus
            .scrollDismissesKeyboard(.never)
            .defaultFocus($searching, true)
            .onAppear { searching = true }
            //on comma press
            .onChange(of: search) {
                if $0.contains(",") {
                    add($0)
                }
            }
            //on submit press
            .onSubmit {
                if !search.isEmpty, !value.contains(search) {
                    add(search)
                    searching = true
                } else {
                    dismiss()
                }
            }
            //reset search when new item added
            .onChange(of: value) { _ in
                if !search.isEmpty {
                    search = ""
                }
            }
    }
}

extension TokenFieldPicker {
    struct ItemView: View {
        var text: String
        var selected: Bool = false
        var onTap: (_ text: String) -> Void
        
        var body: some View {
            Button(action: {
                onTap(text)
            }) {
                Label {
                    Text(text)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                        .imageScale(.large)
                        .foregroundColor(selected ? .accentColor : .tertiaryLabel)
                }
            }
        }
    }
}

extension TokenFieldPicker {
    struct CreateItem: View {
        var text: String
        var onTap: (_ text: String) -> Void
        
        var body: some View {
            Button(action: {
                onTap(text)
            }) {
                Label {
                    Text("Create \(text)")
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
    }
}

extension TokenFieldPicker {
    struct SearchField: View {
        @Binding var search: String
        var prompt: String
        
        @Environment(\.autocorrectionDisabled) private var autocorrectionDisabled
        
        var body: some View {
            Label {
                HStack(spacing: 0) {
                    TextField("", text: $search, prompt: Text(prompt))
                        .submitLabel(.return)
                        .autocorrectionDisabled(autocorrectionDisabled)
                        .textInputAutocapitalization(autocorrectionDisabled ? .never : .sentences)
                        .keyboardType(autocorrectionDisabled ? .webSearch : .default)
                    
                    if !search.isEmpty {
                        Button(action: { search = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } icon: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
            }
        }
    }
}
#endif
