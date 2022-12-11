import SwiftUI
import Backport

struct TokenPicker<S: RawRepresentable<String> & Identifiable, SV: View> {
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""
    @State private var focused = true
    
    @Binding var value: [String]
    var recent: [String]
    var suggestions: ForEach<[S], S.ID, SV>
}

extension TokenPicker {
    func contains(_ string: String) -> Bool {
        let filter = string.trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase
        
        return value.contains(string) || value.contains {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase == filter
        }
    }
    
    func contains(_ suggestion: S) -> Bool {
        contains(suggestion.rawValue)
    }
    
    func add(_ string: String) {
        if !contains(string) {
            value.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    func delete(_ string: String) {
        value = value.filter { $0.localizedLowercase != string.localizedLowercase }
    }
    
    func toggle(_ string: String) {
        if contains(string) {
            delete(string)
        } else {
            add(string)
        }
    }
    
    func submit() {
        if !search.isEmpty {
            search
                .split(separator: ",")
                .map { String($0) }
                .forEach(add)
            
            search = ""
            withAnimation {
                focused = true
            }
        } else {
            dismiss()
        }
    }
}

extension TokenPicker {
    func searched(_ arr: [String]) -> [String] {
        search.isEmpty ? arr : arr.filter { $0.localizedLowercase.contains(search.localizedLowercase) }
    }
    
    func filtered(_ arr: [String]) -> [String] {
        let nonselected = value.isEmpty ? arr : arr.filter { !contains($0) }
        return search.isEmpty ? nonselected : searched(nonselected)
    }
    
    func filtered(_ suggestions: [S]) -> [S] {
        let nonselected = value.isEmpty ? suggestions : suggestions.filter { !contains($0) }
        return search.isEmpty ? nonselected : nonselected.filter { $0.rawValue.localizedLowercase.contains(search.localizedLowercase) }
    }
}

extension TokenPicker: View {
    func render(_ val: String) -> some View {
        Button {
            toggle(val)
        } label: {
            Text(val)
        }
    }
    
    func render(_ suggestion: S) -> some View {
        Button {
            toggle(suggestion.rawValue)
        } label: {
            suggestions.content(suggestion)
        }
    }
    
    @ViewBuilder
    func selected() -> some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyHStack {
                        ForEach(
                            searched(value),
                            id: \.self,
                            content: render
                        )
                    }
                    .frame(height: 36)
                    .scenePadding([.horizontal, .bottom])
                    .onChange(of: searched(value)) {
                        if let last = $0.last {
                            withAnimation {
                                proxy.scrollTo(last, anchor: .trailing)
                            }
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.accentColor)
            .opacity(searched(value).isEmpty ? 0 : 1)
            .frame(maxHeight: searched(value).isEmpty ? 0 : nil)
            
            Divider().opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            selected()
            
            List {
                Section {
                    if !filtered(recent).isEmpty {
                        ForEach(
                            filtered(recent),
                            id: \.self,
                            content: render
                        )
                        .foregroundColor(.primary)
                    }
                } header: {
                    if !filtered(recent).isEmpty {
                        HStack {
                            Text("Recent")
                            
                            Spacer()
                            
                            Button("Select all") {
                                _ = filtered(recent).map(add)
                            }
                                .controlSize(.small)
                        }
                    }
                }
                
                ForEach(
                    filtered(suggestions.data).filter { !recent.contains($0.rawValue) },
                    content: render
                )
                    .foregroundColor(.primary)
            }
        }
            //search
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Add tag")
            .searchFocused($focused)
            .searchBar(withToolbar: true, cancelable: false, autoReturnKey: false)
            .backport.scrollDismissesKeyboard(.never)
            .animation(.default, value: searched(value))
            .onChange(of: value) { _ in search = "" }
            .onChange(of: search) { if $0.contains(",") { submit() } }
            .onSubmit(of: .search, submit)
    }
}
