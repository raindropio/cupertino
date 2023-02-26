import SwiftUI
import UI
import API
import Features

extension Folder {
    struct Status: View {
        @EnvironmentObject private var r: RaindropsStore
        var find: FindBy
        
        var body: some View {
            Memorized(find: find, total: r.state.total(find))
        }
    }
}

extension Folder.Status {
    fileprivate struct Memorized: View {
        @Environment(\.editMode) private var editMode
        
        var find: FindBy
        var total: Int
        
        var body: some View {
            Section {
                HStack(spacing: 0) {
                    Text("\(total) items")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    SortRaindropsButton(find)
                        .labelStyle(.titleOnly)
                        .fixedSize()
                    
                    ViewConfigRaindropsButton(find)
                        .labelStyle(.iconOnly)
                        .fixedSize()
                }
                .pickerStyle(.menu)
                .imageScale(.large)
                .labelsHidden()
                .lineLimit(1)
                .scenePadding(.leading)
            }
            .font(.callout)
            .controlSize(.small)
            .clearSection()
            .contentTransition(.identity)
            .disabled(editMode?.wrappedValue == .active)
            .opacity(total > 0 ? 1 : 0)
        }
    }
}
