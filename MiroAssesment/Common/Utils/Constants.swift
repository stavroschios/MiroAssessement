import SwiftUI

enum Constants {
    enum Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    enum FontSize {
        static let tiny: CGFloat = 10
        static let small: CGFloat = 12
        static let medium: CGFloat = 14
        static let large: CGFloat = 18
        static let extraLarge: CGFloat = 22
        static let headline: CGFloat = 28
    }
    
    enum ImageSize {
        static let avatar: CGFloat = 100
        static let smallAvatar: CGFloat = 40
        static let icon: CGFloat = 24
    }
    
    enum Animations {
        static let standard = Animation.easeInOut(duration: 0.3)
        static let skeletonDuration: Double = 1.5
    }
    
    enum Colors {
        static let primaryBackground = Color(hex: "121212")
        static let secondaryBackground = Color(hex: "1E1E1E")
        static let cardBackground = Color(hex: "222222")
        static let primaryText = Color.white
        static let secondaryText = Color(hex: "AAAAAA")
        static let accent = Color(hex: "1DB954")
        static let divider = Color(hex: "2C2C2C")
        static let error = Color(hex: "E55934")
        
        static let skeletonDark = Color(hex: "1F1F1F")
        static let skeletonLight = Color(hex: "2A2A2A")
    }
    
    enum GitHub {
        static let baseURL = "https://github.com"
        static let apiURL = "https://api.github.com"
        
        static func avatarURL(username: String, size: Int = 400) -> URL? {
            return URL(string: "\(baseURL)/\(username).png?size=\(size)")
        }
    }
    
    enum Theme {
        static let shadowRadius: CGFloat = 5
        static let shadowOpacity: CGFloat = 0.2
        static let cardPadding = EdgeInsets(
            top: Spacing.medium,
            leading: Spacing.medium,
            bottom: Spacing.medium,
            trailing: Spacing.medium
        )
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
