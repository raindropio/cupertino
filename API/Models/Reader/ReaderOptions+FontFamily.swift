import Foundation

extension ReaderOptions {
    public enum FontFamily: String, CaseIterable, Codable {
        case serif
        case palatino
        case times = "times new roman"
        case trebuchet = "trebuchet ms"
        case georgia
        case verdana
        case monospace
    }
}
