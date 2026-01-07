import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension Persisted {
    final class Storage: Equatable {
        static func == (lhs: Storage, rhs: Storage) -> Bool { lhs === rhs }

        private let encoder = JSONEncoder()
        private let decoder = JSONDecoder()
        private let fileUrl: URL?
        private var pending: Value?
        private var isDirty = false

        init(_ key: String) {
            let folder = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupName)!
                .appendingPathComponent("Library/Persisted")
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            fileUrl = folder.appendingPathComponent("\(key).json")

            #if canImport(UIKit)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(flush),
                name: UIApplication.didEnterBackgroundNotification,
                object: nil
            )
            #endif
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        func load(transform: ((Value) -> Value)?) -> Value? {
            guard let fileUrl,
                  let data = try? Data(contentsOf: fileUrl),
                  let value = try? decoder.decode(Value.self, from: data)
            else { return nil }
            return transform?(value) ?? value
        }

        func save(_ value: Value) {
            pending = value
            isDirty = true
        }

        @objc private func flush() {
            guard isDirty, let fileUrl, let value = pending else { return }
            guard let data = try? encoder.encode(value) else { return }
            try? data.write(to: fileUrl, options: .atomic)
            isDirty = false
        }
    }
}
