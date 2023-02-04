import SwiftUI
import UI
import API
import Features

extension Finder {
    struct Status: View {
        @EnvironmentObject private var r: RaindropsStore
        var find: FindBy
        
        var body: some View {
            Memorized(find: find, total: r.state.total(find))
        }
    }
}

extension Finder.Status {
    fileprivate struct Memorized: View {
        @Environment(\.editMode) private var editMode
        
        var find: FindBy
        var total: Int
        
        var body: some View {
            if total > 0 {
                HStack {
                    Text("\(total) items")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    SortRaindropsButton(find)
                        .labelStyle(.titleOnly)
                    
                    CustomizeRaindropsButton(find)
                        .labelStyle(.iconOnly)
                }
                .pickerStyle(.menu)
                .imageScale(.large)
                .tint(.secondary)
                .labelsHidden()
                .lineLimit(1)
                .scenePadding(.leading)
                .clearSection()
                .disabled(editMode?.wrappedValue == .active)
            }
        }
    }
}
