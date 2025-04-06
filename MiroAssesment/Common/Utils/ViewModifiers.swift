import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Constants.Theme.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.CornerRadius.medium)
                    .fill(Constants.Colors.cardBackground)
                    .shadow(
                        color: Color.black.opacity(Constants.Theme.shadowOpacity),
                        radius: Constants.Theme.shadowRadius,
                        x: 0, y: 2
                    )
            )
            .drawingGroup()
    }
}

struct LightCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Constants.Theme.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.CornerRadius.medium)
                    .fill(Constants.Colors.cardBackground)
            )
    }
}

struct SearchBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Constants.Spacing.medium)
            .background(Constants.Colors.secondaryBackground)
            .cornerRadius(Constants.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.CornerRadius.medium)
                    .stroke(Constants.Colors.divider, lineWidth: 1)
            )
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.Spacing.large)
            .padding(.vertical, Constants.Spacing.medium)
            .background(Constants.Colors.accent)
            .foregroundColor(.white)
            .font(.system(size: Constants.FontSize.medium, weight: .semibold))
            .cornerRadius(Constants.CornerRadius.medium)
    }
}

struct AvatarModifier: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Constants.Colors.divider, lineWidth: 1.5)
            )
            .shadow(
                color: Color.black.opacity(Constants.Theme.shadowOpacity),
                radius: 3
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
    
    func lightCardStyle() -> some View {
        self.modifier(LightCardModifier())
    }
    
    func searchBarStyle() -> some View {
        self.modifier(SearchBarModifier())
    }
    
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
    
    func avatarStyle(size: CGFloat) -> some View {
        self.modifier(AvatarModifier(size: size))
    }
} 
