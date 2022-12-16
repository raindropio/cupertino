import SwiftUI

struct AuthSplash: View {
    var body: some View {
        TabView {
            Text("Slide 1")
            Text("Slide 2")
        }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle("Welcome")
    }
}
