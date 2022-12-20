import SwiftUI

public extension GroupBoxStyle where Self == DefaultGroupBoxStyle {
    static var board: BoardGroupBoxStyle { .init() }
}

public struct BoardGroupBoxStyle: GroupBoxStyle {
    @Environment(\.isEnabled) private var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        GroupBox {
            LazyVGrid(
                columns: [.init(
                    .adaptive(minimum: 90),
                    spacing: 0
                )],
                spacing: 0
            ) { configuration.content }
                .padding(.vertical, -5)
                .padding(.horizontal, -10)
                .labelStyle(BoardLabelStyle())
                .grayscale(isEnabled ? 0 : 1)
        } label: {
            configuration.label
        }
            .listRowInsets(EdgeInsets())
    }
}

struct BoardLabelStyle: LabelStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.tint.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                configuration.icon
                    .foregroundStyle(.tint)
                    .symbolVariant(.fill)
                    .imageScale(.large)
            }
            
            configuration.title
                .foregroundColor(.primary)
                .font(.subheadline)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
            .contentShape(Rectangle())
    }
}
