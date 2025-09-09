import SwiftUI

struct ExtensionUI: View {
    @StateObject var service: ExtensionService
    @State private var show = true
    
    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                show = false
            }
            .sheet(isPresented: $show, onDismiss: service.close) {
                Main()
                    .environmentObject(service)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
            }
    }
}
