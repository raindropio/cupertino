import SwiftUI
import Backport

public struct DatePresetField<L: View> {
    @Binding var selection: Date?
    var minimumDate: Date?
    var maximumDate: Date?
    var displayedComponents: DatePickerComponents
    var label: () -> L
    
    public init(selection: Binding<Date?>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], label: @escaping () -> L) {
        self._selection = selection
        self.displayedComponents = displayedComponents
        self.label = label
    }
    
    public init(selection: Binding<Date?>, in range: ClosedRange<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], label: @escaping () -> L) {
        self._selection = selection
        self.minimumDate = range.lowerBound
        self.maximumDate = range.upperBound
        self.displayedComponents = displayedComponents
        self.label = label
    }
    
    public init(selection: Binding<Date?>, in range: PartialRangeFrom<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], label: @escaping () -> L) {
        self._selection = selection
        self.minimumDate = range.lowerBound
        self.displayedComponents = displayedComponents
        self.label = label
    }
    
    public init(selection: Binding<Date?>, in range: PartialRangeThrough<Date>, displayedComponents: DatePickerComponents = [.hourAndMinute, .date], label: @escaping () -> L) {
        self._selection = selection
        self.maximumDate = range.upperBound
        self.displayedComponents = displayedComponents
        self.label = label
    }
}

extension DatePresetField: View {
    public var body: some View {
        NavigationLink {
            DatePresetForm(
                selection: $selection,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                displayedComponents: displayedComponents
            )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        label()
                            .labelStyle(.titleOnly)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
        } label: {
            LabeledContent(content: {
                if let selection {
                    if displayedComponents.contains(.date), displayedComponents.contains(.hourAndMinute) {
                        Text(selection, format: .dateTime)
                    } else {
                        Text(selection, style: displayedComponents.contains(.date) ? .date : .time)
                    }
                }
            }, label: label)
        }
    }
}
