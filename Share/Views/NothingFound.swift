import SwiftUI
import UI
import API

struct NothingFound: View {
    @EnvironmentObject private var service: ExtensionService
    
    var body: some View {
        Group {
            if service.containsText {
                AddText()
            } else {
                Generic()
            }
        }
            .presentationDetents([.medium])
    }
}
