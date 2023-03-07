import SwiftUI

struct ExtensionUI: View {
    @State private var isPresented = true
    @StateObject var service: ExtensionService
    
    var body: some View {
        Color.clear
            .sheet(isPresented: $isPresented, onDismiss: service.close) {
                Main()
                    .environmentObject(service)
            }
    }
}
