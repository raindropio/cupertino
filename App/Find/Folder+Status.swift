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
                        .frame(minWidth: 50, alignment: .trailing)
                        .fixedSize()
                }
                    .pickerStyle(.menu)
                    .imageScale(.large)
                    .labelsHidden()
                    .lineLimit(1)
            }
                .font(.callout)
                .controlSize(.small)
                .contentTransition(.identity)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
    }
}
