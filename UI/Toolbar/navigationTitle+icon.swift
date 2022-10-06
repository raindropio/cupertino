import SwiftUI
import Combine

public extension View {
    func navigationTitle<S, I>(_ titleKey: S, icon: @escaping () -> I) -> some View where I: View, S: StringProtocol {
        modifier(CustomTitleView(titleKey: titleKey, icon: icon))
    }
}

fileprivate struct CustomTitleView<S: StringProtocol, I: View>: ViewModifier {
    #if os(iOS)
    @State private var controller: UINavigationController?
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isLargeTitle = true
    #endif
    
    var titleKey: S
    var icon: () -> I
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(titleKey)
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Label(title: {
                        Text(titleKey)
                    }, icon: icon)
                        .labelStyle(.navigationTitle)
                        #if os(iOS)
                        .opacity(isLargeTitle ? 0 : 1)
                        .animation(.easeInOut(duration: 0.15), value: isLargeTitle)
                        #endif
                }
            }
            #if os(iOS)
            .withNavigationController($controller)
            .onChange(of: controller) {
                cancellables = .init()
                
                let largeBarHeight = ($0?.navigationBar.frame.height ?? 0) - 30
                
                $0?.navigationBar.publisher(for: \.frame)
                    .removeDuplicates { ($0.height >= largeBarHeight) == ($1.height >= largeBarHeight) }
                    .sink { isLargeTitle = $0.height >= largeBarHeight }
                    .store(in: &cancellables)
            }
            #endif
    }
}
