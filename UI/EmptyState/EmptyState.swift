import SwiftUI
import Backport

public struct EmptyState<I: View, A: View> {
    var title: String = ""
    var message: Text?
    var icon: (() -> I)?
    var actions: (() -> A)?
    
    public init(
        _ title: String = "",
        message: Text? = nil,
        icon: @escaping () -> I,
        @ViewBuilder actions: @escaping () -> A
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.actions = actions
    }
}

extension EmptyState: View {
    public var body: some View {
        VStack(spacing: 24) {
            if let icon {
                icon()
                    .symbolVariant(.fill)
                    .imageScale(.large)
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 12) {
                if !title.isEmpty {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                if let message {
                    message
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .imageScale(.small)
                }
            }
            
            if let actions {
                actions()
                    .buttonStyle(Backport.glassProminent)
            }
        }
            .padding()
    }
}

extension EmptyState where A == EmptyView {
    public init(
        _ title: String = "",
        message: Text? = nil,
        icon: @escaping () -> I
    ) {
        self.title = title
        self.message = message
        self.icon = icon
    }
}
