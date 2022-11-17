import SwiftUI

public struct EmptyState<I: View, A: View> {
    var title: String = ""
    var message: String = ""
    var icon: (() -> I)?
    var actions: (() -> A)?
    
    public init(
        _ title: String = "",
        message: String = "",
        icon: @escaping () -> I,
        actions: @escaping () -> A
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.actions = actions
    }
}

extension EmptyState: View {
    public var body: some View {
        VStack(spacing: 20) {
            if let icon {
                icon()
                    .symbolVariant(.fill)
                    .imageScale(.large)
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 10) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actions {
                actions()
            }
        }
            .padding()
    }
}

extension EmptyState where A == EmptyView {
    public init(
        _ title: String,
        icon: @escaping () -> I
    ) {
        self.title = title
        self.icon = icon
    }
}

extension EmptyState where A == EmptyView {
    public init(
        message: String,
        icon: @escaping () -> I
    ) {
        self.message = message
        self.icon = icon
    }
}

extension EmptyState where I == EmptyView {
    public init(
        _ title: String,
        message: String,
        actions: @escaping () -> A
    ) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

extension EmptyState where A == EmptyView {
    public init(
        _ title: String,
        message: String,
        icon: @escaping () -> I
    ) {
        self.title = title
        self.message = message
        self.icon = icon
    }
}

extension EmptyState where I == EmptyView, A == EmptyView {
    public init(
        _ title: String = "",
        message: String = ""
    ) {
        self.title = title
        self.message = message
    }
}
