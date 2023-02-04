import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    struct NavigationLink<V: Hashable, L: View>: View {
        var value: V
        var label: () -> L
        
        public init(value: V, label: @escaping () -> L) {
            self.value = value
            self.label = label
        }
        
        public var body: some View {
            if #available(iOS 16, *) {
                SwiftUI.NavigationLink(value: value, label: label)
            } else {
                NavigationLinkValue(value: value, label: label)
            }
        }
    }
}

extension Backport where Wrapped == Any {
    fileprivate struct NavigationLinkValue<V: Hashable, L: View>: View {
        @EnvironmentObject private var service: BackportNavigationService
        
        var value: V
        var label: () -> L
        
        var body: some View {
            SwiftUI.Button(action: {
                service.path.append(value)
            }, label: label)
                .labelStyle(NavigationLinkValueLabelStyle())
        }
    }
    
    struct NavigationLinkValueLabelStyle: LabelStyle {
        public func makeBody(configuration: Configuration) -> some View {
            Label {
                HStack(spacing: 0) {
                    configuration.title
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                        .imageScale(.small)
                        .symbolVariant(.none)
                        .backport.fontWeight(.semibold)
                }
                    .tint(.primary)
            } icon: {
                configuration.icon
            }
        }
    }
}
