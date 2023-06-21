import SwiftUI

enum DatePreset: CaseIterable {
    case tomorrow
    case thisWeekend
    case nextWeek
    case someday
    case none
    
    var date: Date? {
        switch self {
        case .tomorrow: return Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        case .thisWeekend: return Calendar.current.nextDate(after: .now, matching: .init(calendar: .current, weekday: 1), matchingPolicy: .nextTimePreservingSmallerComponents)
        case .nextWeek: return Calendar.current.date(byAdding: .weekOfYear, value: 1, to: .now)!
        case .someday: return Calendar.current.date(byAdding: .day, value: .random(in: 1...365), to: .now)!
        case .none: return nil
        }
    }
    
    var title: String {
        switch self {
        case .tomorrow: return "Tomorrow"
        case .thisWeekend: return "This Weekend"
        case .nextWeek: return "Next Week"
        case .someday: return "Someday"
        case .none: return "None"
        }
    }
    
    var systemImage: String {
        switch self {
        case .tomorrow: return "sun.max"
        case .thisWeekend: return "sofa"
        case .nextWeek: return "briefcase"
        case .someday: return "clock.badge.questionmark"
        case .none: return "slash.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .tomorrow: return .orange
        case .thisWeekend: return .blue
        case .nextWeek: return .indigo
        case .someday: return .mint
        case .none: return .gray
        }
    }
}
