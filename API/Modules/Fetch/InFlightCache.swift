import Foundation

actor InFlightCache {
    private var tasks: [URL: Task<(Data, URLResponse), Error>] = [:]

    func deduplicated(
        for url: URL,
        execute: @Sendable @escaping () async throws -> (Data, URLResponse)
    ) async throws -> (Data, URLResponse) {
        if let existing = tasks[url] {
            return try await existing.value
        }

        let task = Task { try await execute() }
        tasks[url] = task

        do {
            let result = try await task.value
            tasks[url] = nil
            return result
        } catch {
            tasks[url] = nil
            throw error
        }
    }
}
