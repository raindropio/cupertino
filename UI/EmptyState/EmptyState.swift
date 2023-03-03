import SwiftUI

public struct EmptyState<I: View, A: View> {
    var title: String = ""
    var message: Text?
    var icon: (() -> I)?
    var actions: (() -> A)?
    
    public init(
        _ title: String = "",
        message: Text,
        icon: @escaping () -> I,
        @ViewBuilder actions: @escaping () -> A
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.actions = actions
    }
    
    public init(
        _ title: String = "",
        message: String = "",
        icon: @escaping () -> I,
        @ViewBuilder actions: @escaping () -> A
    ) {
        self.title = title
        if !message.isEmpty {
            self.message = Text(message)
        }
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
                }
            }
            
            if let actions {
                actions()
                    .buttonStyle(.bordered)
                    #if os(iOS)
                    .buttonBorderShape(.capsule)
                    #endif
                    .tint(.accentColor)
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
        if !message.isEmpty {
            self.message = Text(message)
        }
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
        if !message.isEmpty {
            self.message = Text(message)
        }
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
        if !message.isEmpty {
            self.message = Text(message)
        }
        self.icon = icon
    }
}

extension EmptyState where I == EmptyView, A == EmptyView {
    public init(
        _ title: String = "",
        message: String = ""
    ) {
        self.title = title
        if !message.isEmpty {
            self.message = Text(message)
        }
    }
}
