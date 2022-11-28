import SwiftUI
import API

struct Share: View {
    @StateObject private var store = Store()
    @StateObject var `extension`: ExtensionService
    
    var body: some View {
        List {
            if let raindrop = `extension`.raindrop {
                Section("Raindrop") {
                    Link(raindrop.link.absoluteString, destination: raindrop.link)
                    Text(raindrop.title)
                }
            }
            
            Section("Files") {
                ForEach(Array(`extension`.files), id: \.self) {
                    Text($0.absoluteString)
                }
            }
        }
    }
}
