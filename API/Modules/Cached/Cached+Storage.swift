import Foundation
import Combine

extension Cached {
    class Storage<Value: Codable>: Equatable {
        static func == (lhs: Storage<Value>, rhs: Storage<Value>) -> Bool {
            true
        }
        
        private let encoder = JSONEncoder()
        private let decoder = JSONDecoder()
        private let publisher: PassthroughSubject<Value, Never> = PassthroughSubject()
        private var bag = Set<AnyCancellable>()
        private var fileUrl: URL
        
        init(_ key: String) {
            fileUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupName)!
                .appendingPathComponent("Library/Caches/\(key).json", isDirectory: false)
            
            publisher
                .subscribe(on: DispatchQueue.global(qos: .background))
                .debounce(for: .seconds(1), scheduler: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.global(qos: .background))
                .sink(receiveValue: persist)
                .store(in: &bag)
        }
        
        func load(transform: ((Value) -> Value)? = nil) -> Value? {
            guard
                let data = FileManager.default.contents(atPath: fileUrl.path),
                let decoded = try? decoder.decode(Value.self, from: data)
            else { return nil }
            
            if let transform {
                return transform(decoded)
            }
            
            return decoded
        }
        
        func save(_ value: Value) {
            publisher.send(value)
        }
        
        private func persist(_ value: Value) {
            try? FileManager.default.removeItem(at: fileUrl)
            
            if let encoded = try? encoder.encode(value) {
                FileManager.default.createFile(atPath: fileUrl.path, contents: encoded, attributes: nil)
            }
        }
    }
}
