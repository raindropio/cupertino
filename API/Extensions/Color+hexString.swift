import SwiftUI

extension Color {
    init?(hexString: String) {
        guard hexString.count == 7, hexString.first == "#"
        else { return nil }
        
        let chars = Array(hexString.dropFirst())
        self.init(red: .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue: .init(strtoul(String(chars[4...5]),nil,16))/255)
    }
    
    var hexString: String? {
        guard let components = cgColor?.components, components.count >= 3
        else { return nil }

        let hexString = String.init(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(components[0] * 255)),
            lroundf(Float(components[1] * 255)),
            lroundf(Float(components[2] * 255))
        )
        return hexString
    }
}
