import SwiftUI

public struct MultiPicker<Data: RandomAccessCollection, Content: View, LabelContent: View> where Data.Element: Identifiable {
    @Binding var selection: [Data.Element.ID]
    var prompt: LocalizedStringKey
    var content: (String) -> ForEach<Data, Data.Element.ID, Content>
    var label: LabelContent
    
    private var insertable = Data.Element.ID.self is String.Type
    @State private var filter: String = ""
    @Environment(\.multiPickerStyle) private var style
    @Environment(\.autocorrectionDisabled) private var autocorrectionDisabled
    
    public init(
        selection: Binding<[Data.Element.ID]>,
        prompt: LocalizedStringKey = "",
        content: @escaping (String) -> ForEach<Data, Data.Element.ID, Content>,
        label: @escaping () -> LabelContent
    ) {
        self._selection = selection
        self.prompt = prompt
        self.content = content
        self.label = label()
    }
}

//internals
extension MultiPicker {
    private func isActive(_ element: Data.Element) -> Bool {
        selection.contains(element.id)
    }
    
    private func toggle(_ element: Data.Element) {
        if isActive(element) {
            selection = selection.filter { $0 != element.id }
        } else {
            selection.append(element.id)
        }
    }
    
    private func submit() {
        if insertable, !filter.isEmpty {
            filter.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .compactMap { $0 as? Data.Element.ID }
                .forEach { id in
                    if !selection.contains(id) {
                        selection.append(id)
                    }
                }
        }
        
        filter = ""
    }
    
    private func showInsert(_ data: Data) -> Bool {
        guard insertable, !filter.isEmpty, let newId = filter as? Data.Element.ID else { return false }
        return !selection.contains(newId) && !data.contains(where: { item in
            item.id == newId
        })
    }
}

extension MultiPicker: View {
    @ViewBuilder
    var inline: some View {
        let items = content(filter)
        
        List {
            if showInsert(items.data) {
                Button("Add \(filter)", action: submit)
            }
            
            ForEach(items.data) { item in
                Button {
                    toggle(item)
                } label: {
                    HStack {
                        items.content(item)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "checkmark")
                            .opacity(isActive(item) ? 1 : 0)
                    }
                }
            }
        }
            .searchable(
                text: $filter,
                tokens: searchTokens,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: prompt
            ) { Text($0.id) }
            .textInputAutocapitalization(autocorrectionDisabled ? .never : .sentences)
            .searchFocus(.always)
            .searchBar(
                withToolbar: true,
                cancelable: false,
                clearable: false,
                tokenBackgroundColor: Color.accentColor.opacity(0.65)
            )
            .animation(.easeIn(duration: 0.15), value: selection)
            .onSubmit(of: .search, submit)
            .onChange(of: filter) {
                if $0.contains(",") {
                    submit()
                }
            }
    }
    
    @ViewBuilder
    var menu: some View {
        NavigationLink {
            inline
                .navigationTitle("Selected \(selection.count)")
        } label: {
            LabeledContent {
                Text(selection.compactMap { $0 as? String }.joined(separator: ", "))
                    .lineLimit(1)
            } label: {
                label
            }
        }
    }
    
    public var body: some View {
        switch style {
        case .automatic, .menu:
            menu
            
        case .inline:
            inline
        }
    }
}

extension MultiPicker {
    private var searchTokens: Binding<[SearchToken]> {
        if insertable {
            return .init(
                get: {
                    selection.compactMap {
                        guard let id = $0 as? String else { return nil }
                        return SearchToken(id: id)
                    }
                },
                set: { new in
                    selection = new.compactMap { $0.id as? Data.Element.ID }
                }
            )
        }
        
        return .constant([])
    }

    private struct SearchToken: Identifiable {
        var id: String
    }
}
