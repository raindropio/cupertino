import SwiftUI
import API
import UI
import Backport
import Common

struct SuggestedFilters: View {
    @EnvironmentObject private var f: FiltersStore
    @Binding var find: FindBy
    
    var body: some View {
        Memorized(
            find: $find,
            items: f.state.simple(find)
        )
    }
}

extension SuggestedFilters {
    fileprivate struct Memorized: View {
        @Binding var find: FindBy
        var items: [Filter]
        
        var body: some View {
            Section {
                if !items.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(items) { item in
                                Button {
                                    find.filters.append(item)
                                } label: {
                                    FilterRow(item)
                                }
                            }
                        }
                        .scenePadding(.horizontal)
                    }
                    .labelStyle(LS())
                    .clearSection()
                }
            }
        }
    }
}

fileprivate struct LS: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .symbolVariant(.fill)
            
            configuration.title
                .font(.subheadline)
                .foregroundColor(.primary)
        }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                .tint.opacity(0.15),
                in: Capsule(style: .continuous)
            )
    }
}
