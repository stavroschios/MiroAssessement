import SwiftUI

struct GitHubIcon: View {
    var size: CGFloat = 64
    var color: Color = Constants.Colors.accent
    
    var body: some View {
        Image(systemName: "cat.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(color)
            .background(
                Circle()
                    .fill(Constants.Colors.cardBackground)
                    .frame(width: size * 1.5, height: size * 1.5)
                    .shadow(
                        color: Color.black.opacity(Constants.Theme.shadowOpacity),
                        radius: Constants.Theme.shadowRadius,
                        x: 0, y: 2
                    )
            )
    }
}

struct GitHubIconView: View {
    var body: some View {
        VStack(spacing: Constants.Spacing.medium) {
            GitHubIcon()
            
            Text("GitHub")
                .font(.system(size: Constants.FontSize.large, weight: .bold))
                .foregroundColor(Constants.Colors.primaryText)
            
            Text("Explorer")
                .font(.system(size: Constants.FontSize.small))
                .foregroundColor(Constants.Colors.accent)
        }
    }
}

#Preview {
    ZStack {
        Constants.Colors.primaryBackground
            .ignoresSafeArea()
        
        GitHubIconView()
    }
} 