import SwiftUI

struct DeveloperRowItem: View {
    let user: RecommendedUser
    
    var body: some View {
        HStack(spacing: Constants.Spacing.medium) {
            GitHubAvatarView(username: user.username, size: 50)
            
            VStack(alignment: .leading, spacing: Constants.Spacing.tiny) {
                Text(user.username)
                    .foregroundColor(Constants.Colors.primaryText)
                    .font(.system(size: Constants.FontSize.medium, weight: .medium))
                
                Text(user.bio ?? "")
                    .foregroundColor(Constants.Colors.secondaryText)
                    .font(.system(size: Constants.FontSize.small))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Follow")
                    .font(.system(size: Constants.FontSize.small, weight: .medium))
                    .foregroundColor(Constants.Colors.accent)
                    .padding(.horizontal, Constants.Spacing.small)
                    .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.CornerRadius.small)
                            .stroke(Constants.Colors.accent, lineWidth: 1)
                    )
            }
        }
        .padding()
    }
}
