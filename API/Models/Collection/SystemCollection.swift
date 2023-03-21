import SwiftUI

public struct SystemCollection: CollectionType {
    public var id: Int
    public var count: Int = 0
    public var view: CollectionView = .list

    public var title: String {
        switch id {
        case 0: return "All items"
        case -1: return "Unsorted"
        case -99: return "Trash"
        default: return "Unknown"
        }
    }
    
    public var systemImage: String {
        switch id {
        case 0: return "cloud"
        case -1: return "tray"
        case -99: return "trash"
        default: return "folder"
        }
    }
    
    public var color: Color? {
        switch id {
        case -1: return .green
        case -99: return .gray
        default: return nil
        }
    }
    
    public var access: CollectionAccess {
        .init(level: .owner, draggable: false)
    }
}
