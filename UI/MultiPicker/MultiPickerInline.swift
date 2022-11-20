import SwiftUI

struct MultiPickerInline<S: Hashable, C: View, SU: View>: View {
    @State private var filter = ""
    
    var selection: Binding<Set<S>>
    var content: (S) -> C
    var suggestions: ((_ filter: String) -> SU)?
    
    private func submit() {
        if selection is Binding<Set<String>> {
            if !filter.isEmpty {
                filter.split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                    .forEach {
                        selection.wrappedValue.insert($0 as! S)
                    }
            }
        }
        
        filter = ""
    }
    
    var body: some View {
        List(selection: selection) {            
            suggestions?(filter)
        }
            .searchable(text: $filter, placement: .navigationBarDrawer(displayMode: .always))
            .onSubmit(of: .search, submit)
            .onChange(of: filter) {
                if $0.contains(",") {
                    submit()
                }
            }
            .environment(\.editMode, .constant(.active))
    }
}
