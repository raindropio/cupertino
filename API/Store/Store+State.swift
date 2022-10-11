import Foundation

protocol State {
    typealias Reducer = (inout Self, Store.Action) async throws -> Store.Action?
    static var reducer: Reducer { get }
}
