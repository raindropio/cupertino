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
        if !search.isEmpty {
            search
                .split(separator: ",")
                .map { String($0) }
                .forEach(add)
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
            .animation(.default, value: search)
            .filterable(text: $search, icon: "plus", prompt: "Add tag") {
                if !searched(value).isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(
                                searched(value),
                                id: \.self,
                                content: render
                            )
                        }
                            .frame(height: 36)
                            .scenePadding([.horizontal, .top])
                    }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .tint(.accentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                }
            }
            .animation(.default, value: value)
            .onChange(of: value) { _ in search = "" }
            .onChange(of: search) { if $0.contains(",") { submit() } }
            .onSubmit(submit)
    }
}
