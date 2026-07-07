import SwiftUI

enum Theme {
    static let accent = Color(hex: "#5B2A5E")
    static let accent2 = Color(hex: "#F2C57C")
    static let background = Color(hex: "#150A17")
    static let cardBackground = Color(hex: "#150A17").opacity(0.6)
    static let ink = Color.white.opacity(0.92)
    static let inkMuted = Color.white.opacity(0.55)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255
        let g = Double((v >> 8) & 0xFF) / 255
        let b = Double(v & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
