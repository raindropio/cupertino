import Foundation

protocol State {
    typealias Reducer<Action> = (inout Self, Action) async throws -> Store.Action?
    static var reducer: Reducer<Store.Action> { get }
}
