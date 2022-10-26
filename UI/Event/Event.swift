import Combine

class Event: ObservableObject {
    public let publisher: PassthroughSubject<(String, Any), Never> = PassthroughSubject()
    
    public func send(_ name: String, object: Any) {
        publisher.send((name, object))
    }
}
