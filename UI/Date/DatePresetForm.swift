import SwiftUI

struct DatePresetForm: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selection: Date?
    var minimumDate: Date?
    var maximumDate: Date?
    var displayedComponents: DatePickerComponents
    
    var body: some View {
        Form {
            Section {
                ForEach(DatePreset.allCases, id: \.self) { preset in
                    if preset.date != selection {
                        Button {
                            selection = preset.date
                            dismiss()
                        } label: {
                            Label {
                                Text(preset.title)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: preset.systemImage)
                                    .foregroundColor(preset.color)
                                    .symbolVariant(.fill)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            
            DatePicker(
                selection: .init { selection ?? .now } set: { selection = $0 },
                in: (minimumDate ?? .distantPast) ... (maximumDate ?? .distantFuture),
                displayedComponents: displayedComponents
            ) {}
                .datePickerStyle(.graphical)
        }
            .backport.scrollBounceBehavior(.basedOnSize)
            .safeAnimation(.default, value: selection)
    }
}
