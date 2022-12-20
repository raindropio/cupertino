import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func toolbarRole(_ role: Backport.ToolbarRole) -> some View {
        if #available(iOS 16, *) {
            content.toolbarRole(role.convert())
        } else {
            content
        }
    }
    
    @available(iOS, deprecated: 16.0)
    @ViewBuilder
    func toolbar(_ visibility: SwiftUI.Visibility, for bars: Backport.ToolbarPlacement...) -> some View {
        if #available(iOS 16, *) {
            content
                .toolbar(visibility, for: bars.contains(.automatic) ? .automatic : nil)
                .toolbar(visibility, for: bars.contains(.bottomBar) ? .bottomBar : nil)
                .toolbar(visibility, for: bars.contains(.navigationBar) ? .navigationBar : nil)
                .toolbar(visibility, for: bars.contains(.tabBar) ? .tabBar : nil)
        } else {
            content
                .overlay(ToolbarVisibility(visibility: visibility, bars: bars).opacity(0))
        }
    }
    
    @available(iOS, deprecated: 16.0)
    @ViewBuilder
    func toolbarBackground(_ visibility: SwiftUI.Visibility, for bars: Backport.ToolbarPlacement...) -> some View {
        if #available(iOS 16, *) {
            content
                .toolbarBackground(visibility, for: bars.contains(.automatic) ? .automatic : nil)
                .toolbarBackground(visibility, for: bars.contains(.bottomBar) ? .bottomBar : nil)
                .toolbarBackground(visibility, for: bars.contains(.navigationBar) ? .navigationBar : nil)
                .toolbarBackground(visibility, for: bars.contains(.tabBar) ? .tabBar : nil)
        } else {
            content
        }
    }
}

extension View {
    @available(iOS 16.0, *)
    @ViewBuilder
    func toolbar(_ visibility: SwiftUI.Visibility, for bar: SwiftUI.ToolbarPlacement?) -> some View {
        if let bar {
            toolbar(visibility, for: bar)
        } else {
            self
        }
    }
    
    @available(iOS 16.0, *)
    @ViewBuilder
    func toolbarBackground(_ visibility: SwiftUI.Visibility, for bar: SwiftUI.ToolbarPlacement?) -> some View {
        if let bar {
            toolbarBackground(visibility, for: bar)
        } else {
            self
        }
    }
}

extension Backport {
    public enum ToolbarRole {
        case automatic
        case navigationStack
        case browser
        case editor
        
        @available(iOS 16.0, *)
        func convert() -> SwiftUI.ToolbarRole {
            switch self {
            case .automatic: return .automatic
            case .navigationStack: return .navigationStack
            case .browser: return .browser
            case .editor: return .editor
            }
        }
    }
    
    public enum ToolbarPlacement {
        case automatic
        case bottomBar
        case navigationBar
        case tabBar
    }
}
