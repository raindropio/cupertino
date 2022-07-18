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
            TokenFieldPicker(title: title, value: $value, prompt: prompt, suggestions: suggestions, autocorrectionDisabled: autocorrectionDisabled)
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
    var autocorrectionDisabled = false
    
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""
    @FocusState private var searching: Bool
    
    func add(_ text: String) {
        withAnimation {
            value = value + text
                .split(separator: ",")
                .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
    }
    
    var body: some View {
        let valueFiltered = TokenFieldUtils.filter(value, value: [], by: search)
        let suggestionsFiltered = TokenFieldUtils.filter(suggestions, value: value, by: search)
        
        List(
            selection: .init(
                get: { Set(value) },
                set: { next in
                    withAnimation {
                        value = value.filter { next.contains($0) } + next.filter { !value.contains($0) }
                    }
                }
            )
        ) {
            Section {
                Label {
                    HStack(spacing: 0) {
                        TextField(title, text: $search, prompt: Text(prompt))
                            .focused($searching)
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
                    Image(systemName: "plus")
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                ForEach(valueFiltered, id: \.self) {
                    Text($0)
                }
            }
            
            Section {
                ForEach(suggestionsFiltered, id:\.self) {
                    Text($0)
                }
            }
        }
            //state & animation
            .environment(\.editMode, .constant(.active))
            //appearance
            .controlSize(.large)
            .navigationTitle(value.isEmpty ? title : "Selected \(value.count)")
            .toolbar(.hidden, in: .tabBar)
            //default focus
            .scrollDismissesKeyboard(.never)
            .defaultFocus($searching, true)
            .task { searching = true }
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
                    withAnimation {
                        search = ""
                    }
                }
            }
    }
}
#endif
