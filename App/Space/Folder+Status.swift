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
            if total > 0 {
                Section {
                    HStack {
                        Text("\(total) items")
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        SortRaindropsButton(find)
                            .labelStyle(.titleOnly)
                            .fixedSize()
                        
                        CustomizeRaindropsButton(find)
                            .labelStyle(.iconOnly)
                            .fixedSize()
                    }
                    .pickerStyle(.menu)
                    .imageScale(.large)
                    .labelsHidden()
                    .lineLimit(1)
                    .scenePadding(.leading)
                }
                .clearSection()
                .disabled(editMode?.wrappedValue == .active)
            }
        }
    }
}
