import SwiftUI
import API

extension FiltersEditMode {
    enum Action: Hashable, Identifiable {
        case merge(Set<Filter>)
        case delete(Set<Filter>)
        
        var id: Int { hashValue }
    }
}

private struct FiltersEditModeActionKey: EnvironmentKey {
    static let defaultValue: Binding<FiltersEditMode.Action?>? = nil
}

extension EnvironmentValues {
    var filtersEditModeAction: Binding<FiltersEditMode.Action?>? {
        get { self[FiltersEditModeActionKey.self] }
        set { self[FiltersEditModeActionKey.self] = newValue }
    }
}
