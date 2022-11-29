import SwiftUI
import UI
import Common

struct AddStack: View {
    @Environment(\.dismiss) private var dismiss
    @State private var add: Add?

    var collection: Int?
    init(collection: Int? = nil) {
        self.collection = collection == 0 ? -1 : collection
    }

    var body: some View {
        Group {
            switch add {
            case nil:
                Home(add: $add)
                
            case .link(let string):
                NewLink(string, collection: collection)
                
            case .collection:
                CollectionStack(collection != nil ? .parent(collection!) : .group())
                
            case .files(let files):
                UploadFilesStack(files, collection: collection)
            }
        }
        .frame(idealWidth: 400, idealHeight: 340)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: add)
    }
}

extension AddStack {
    enum Add: Equatable {
        case link(String = "")
        case collection
        case files([URL])
    }
}
