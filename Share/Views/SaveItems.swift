import SwiftUI

struct SaveItems: View {
    @EnvironmentObject private var service: ExtensionService
    
    var body: some View {
        NavigationStack {
            Form {
                if let preprocessed = service.preprocessed {
                    Section("Preprocessed") {
                        Text("\(preprocessed)")
                    }
                }
                
                Section("Items") {
                    ForEach(Array(service.items), id: \.self) {
                        Text($0.absoluteString)
                    }
                }
            }
        }
    }
}
