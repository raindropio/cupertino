import Foundation
import UniformTypeIdentifiers

final class MultipartBodyStream: InputStream {
    private var streams: [InputStream]
    private var current = 0

    private var _status: Stream.Status = .notOpen
    private var _error: Error?

    private weak var _delegate: StreamDelegate?

    init(_ streams: [InputStream]) {
        self.streams = streams
        super.init(data: Data())
    }

    override var streamStatus: Stream.Status { _status }
    override var streamError: Error?        { _error }

    override var delegate: StreamDelegate? {
        get { _delegate }
        set { _delegate = newValue }
    }

    override func schedule(in runLoop: RunLoop, forMode mode: RunLoop.Mode) {
        for s in streams { s.schedule(in: runLoop, forMode: mode) }
    }

    override func remove(from runLoop: RunLoop, forMode mode: RunLoop.Mode) {
        for s in streams { s.remove(from: runLoop, forMode: mode) }
    }

    override func open() {
        guard _status == .notOpen else { return }
        _status = .opening
        streams.first?.open()
        _status = .open
    }

    override func close() {
        guard _status != .closed else { return }
        streams.forEach { $0.close() }
        _status = .closed
    }

    override var hasBytesAvailable: Bool {
        while current < streams.count {
            if streams[current].hasBytesAvailable { return true }
            streams[current].close()
            current += 1
            streams[safe: current]?.open()
        }
        _status = .atEnd
        return false
    }

    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        guard _status == .open else { return 0 }

        while current < streams.count {
            let n = streams[current].read(buffer, maxLength: len)
            if n > 0 { return n }
            if n < 0 {
                _error  = streams[current].streamError
                _status = .error
                return -1
            }
            streams[current].close()
            current += 1
            streams[safe: current]?.open()
        }

        _status = .atEnd
        return 0
    }

    override func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>,
                            length len: UnsafeMutablePointer<Int>) -> Bool {
        false
    }

    override func property(forKey key: Stream.PropertyKey) -> Any? {
        streams.first?.property(forKey: key)
    }

    override func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        streams.first?.setProperty(property, forKey: key) ?? false
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
