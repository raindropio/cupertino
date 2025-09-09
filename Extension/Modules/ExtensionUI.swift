import SwiftUI

struct ExtensionUI: View {
    @StateObject var service: ExtensionService
    @State private var show = false
    
    var body: some View {
        Color.clear
            //load and show sheet
            .task(priority: .userInitiated) {
                defer { show = true }
                await service.load()
            }
            //automatically show after 3 seconds, to prevent freezed state
            .task {
                defer { show = true }
                try? await Task.sleep(nanoseconds: 3_000_000_000)
            }
            .sheet(isPresented: $show, onDismiss: service.close) {
                Main()
                    .environmentObject(service)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
            }
    }
}
