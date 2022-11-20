import SwiftUI

struct MultiPickerMenu<S: Hashable, C: View, SU: View>: View {
    var title: String
    var selection: Binding<Set<S>>
    var content: (S) -> C
    var suggestions: ((_ filter: String) -> SU)?
    
    var body: some View {
        NavigationLink {
            MultiPickerInline(selection: selection, content: content, suggestions: suggestions)
                .navigationTitle(title)
        } label: {
            if let strings = selection as? Binding<Set<String>> {
                if strings.wrappedValue.isEmpty {
                    Text(title)
                } else {
                    Text(strings.wrappedValue, format: .list(type: .and))
                }
            } else {
                Text(title)
                    .badge(selection.wrappedValue.count)
            }
        }
    }
}
