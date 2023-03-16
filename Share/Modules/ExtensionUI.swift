import SwiftUI

struct ExtensionUI: View {
    @StateObject var service: ExtensionService
    
    var body: some View {
        Color.clear.sheet(isPresented: $service.loaded, onDismiss: service.close) {
            Main()
                .environmentObject(service)
        }
    }
}
