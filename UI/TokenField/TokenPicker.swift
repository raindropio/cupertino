import SwiftUI

struct TokenPicker<S: RawRepresentable<String> & Identifiable, SV: View> {
    @State private var search = ""
    
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
        if !search.isEmpty, !contains(search) {
            add(search)
        }
        
        search = ""
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
    
    var body: some View {
        List {
            if !search.isEmpty, !contains(search) {
                Button(action: submit) {
                    Label(search, systemImage: "plus")
                }
            }
            
            if !filtered(recent).isEmpty {
                Section {
                    ForEach(
                        filtered(recent),
                        id: \.self,
                        content: render
                    )
                        .foregroundColor(.primary)
                } header: {
                    HStack {
                        Text("Recent")
                        
                        Spacer()
                        
                        Button("Select all") {
                            _ = recent.map(add)
                        }
                            .controlSize(.small)
                            .buttonStyle(.bordered)
                            .tint(.secondary)
                    }
                }
            }
            
            ForEach(
                filtered(suggestions.data),
                content: render
            )
                .foregroundColor(.primary)
        }
            .scrollDismissesKeyboard(.interactively)
            .modifier(Bubbles {
                ForEach(
                    searched(value),
                    id: \.self,
                    content: render
                )
            })
            .animation(.default, value: value)
            .animation(.default, value: search)
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: value) { _ in search = "" }
            .onSubmit(of: .search, submit)
    }
}

struct Bubbles<B: RandomAccessCollection, BV: View>: ViewModifier where B.Element: Hashable {
    var items: ForEach<B, B.Element, BV>
    
    init(items: () -> ForEach<B, B.Element, BV>) {
        self.items = items()
    }
    
    var selected: some View {
        WStack(alignment: .leading) { items }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .tint(.accentColor)
    }
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    if !items.data.isEmpty {
                        selected
                            .scenePadding([.horizontal, .bottom])
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Divider().opacity(0.5)
                }
                    .background(.bar)
            }
            .animation(.default, value: items.data.isEmpty)
    }
}
