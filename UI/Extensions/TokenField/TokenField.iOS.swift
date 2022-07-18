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
            Label(title, systemImage: "number")
        }
    }
}

struct TokenFieldPicker: View {
    var title: String = ""
    @Binding public var value: [String]
    var prompt: String
    var suggestions: [String]
    var autocorrectionDisabled = false
    
    @State private var search = ""
    @FocusState private var searching: Bool
    
    var body: some View {
        let existing = TokenFieldUtils.filter(suggestions, value: [], by: search)
        let unknown = TokenFieldUtils.filter(value, value: suggestions, by: search)
        let newOne = !search.isEmpty && !(existing + unknown).contains { $0 == search }
        
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Divider()
                
                TextField(title, text: $search, prompt: Text(prompt))
                    .padding()
                    .focused($searching)
                    .submitLabel(.return)
                    .autocorrectionDisabled(autocorrectionDisabled)
                    .textInputAutocapitalization(autocorrectionDisabled ? .never : .sentences)
                    .keyboardType(autocorrectionDisabled ? .webSearch : .default)
            }
                .textFieldStyle(.roundedBorder)
                .controlSize(.large)
                .zIndex(1)
                .background(.regularMaterial)
                .background(.systemGroupedBackground)
            
            List(
                selection: .init(
                    get: { Set(value) },
                    set: { next in value = value.filter { next.contains($0) } + next.filter { !value.contains($0) } }
                )
            ) {
                if newOne {
                    Text("Add \(search)").tag(search)
                }
                
                Section {
                    ForEach(unknown, id:\.self) {
                        Text($0)
                    }
                }
                
                Section {
                    ForEach(existing, id:\.self) {
                        Text($0)
                    }
                }
                
                Section {
                    Spacer()
                    Spacer()
                }.listRowBackground(Color.clear).listRowSeparator(.hidden)
            }
                .environment(\.editMode, .constant(.active))
                .animation(.easeInOut(duration: 0.25), value: value)
                .scrollDismissesKeyboard(.never)
        }
            .navigationTitle(value.isEmpty ? title : "Selected \(value.count)")
            .toolbar(.hidden, in: .tabBar)
            .defaultFocus($searching, true)
            .task { searching = true }
            .onSubmit {
                if !search.isEmpty, !value.contains(search) {
                    value.append(search)
                }
                searching = true
            }
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
