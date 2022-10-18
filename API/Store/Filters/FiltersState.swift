import Foundation
import SwiftUI

public struct FiltersState: Equatable {
    typealias Groups = [ FindBy : Group ]
    @Cached("fs-groups", cachable) var groups = Groups()
}
