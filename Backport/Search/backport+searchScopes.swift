import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func searchScopes<V: Hashable, S: View>(_ scope: Binding<V>, @ViewBuilder scopes: @escaping () -> S) -> some View {
        if #available(iOS 16, *) {
            content.searchScopes(scope, scopes: scopes)
        } else {
            content
                //.modifier(SS(scope: scope, scopes: scopes))
        }
    }
}

//extension Backport {
//    fileprivate struct SS<V: Hashable, S: View>: ViewModifier {
//        @State private var searchFocused = false
//        @Binding var scope: V
//        var scopes: () -> S
//        
//        private var isEmpty: Bool {
//            let view = scopes()
//            return "\(view)" == "nil"
//        }
//        
//        private var showScope: Bool {
//            searchFocused && !isEmpty
//        }
//        
//        func body(content: Content) -> some View {
//            VStack(spacing: 0) {
//                if showScope {
//                    Picker("", selection: $scope, content: scopes)
//                        .pickerStyle(.segmented)
//                        .scenePadding(.horizontal)
//                        .scenePadding(.bottom)
//                        .background(.bar)
//                        .overlay(alignment: .bottom) {
//                            Divider().opacity(0.7)
//                        }
//                        .transition(.move(edge: .bottom).combined(with: .opacity))
//                }
//                
//                content
//                    .animation(nil, value: showScope)
//            }
//                .animation(.default, value: showScope)
//                .searchFocused($searchFocused)
//        }
//    }
//}
