import SwiftUI

public struct Admonition<C: View> {
    var role: Role
    var content: () -> C
    
    public init(role: Role = .note, content: @escaping () -> C) {
        self.role = role
        self.content = content
    }
}

extension Admonition where C == Text {
    public init<S: StringProtocol>(_ text: S, role: Role = .note) {
        self.role = role
        self.content = { Text(text) }
    }
}

extension Admonition: View {
    public var body: some View {
        Label(title: content) {
            Image(systemName: role.systemImage)
                .symbolVariant(.fill)
        }
            .scenePadding()
            .tint(role.tint)
            .listItemTint(role.tint)
            .listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity)
            .background(role.tint.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
