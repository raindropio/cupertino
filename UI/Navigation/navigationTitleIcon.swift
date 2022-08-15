import SwiftUI

public extension View {
    func navigationTitle<S, Content>(_ titleKey: S, @ViewBuilder icon: () -> Content) -> some View where Content : View, S : StringProtocol {
        navigationTitle(titleKey)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label(title: {
                        Text(titleKey)
                    }, icon: icon)
                        .labelStyle(.navigationTitle)
                }
            }
    }
    
    func navigationTitle<Content>(_ title: Binding<String>, @ViewBuilder icon: () -> Content) -> some View where Content : View {
        navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label(title: {
                        Text(title.wrappedValue)
                    }, icon: icon)
                        .labelStyle(.navigationTitle)
                }
            }
    }
}
