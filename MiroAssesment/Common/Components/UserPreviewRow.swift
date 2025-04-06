import SwiftUI

struct UserPreviewRow: View {
    let user: UserPreview
    
    var body: some View {
        HStack(spacing: Constants.Spacing.medium) {
            GitHubAvatarView(username: user.login, size: Constants.ImageSize.smallAvatar)
                .layoutPriority(1)
            
            VStack(alignment: .leading, spacing: Constants.Spacing.tiny) {
                Text(user.login)
                    .font(.system(size: Constants.FontSize.medium, weight: .medium))
                    .foregroundColor(Constants.Colors.primaryText)
                    .lineLimit(1)
                
                Text("@\(user.login)")
                    .font(.system(size: Constants.FontSize.tiny))
                    .foregroundColor(Constants.Colors.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer(minLength: Constants.Spacing.medium)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Constants.Colors.secondaryText)
                .font(.system(size: Constants.FontSize.small))
        }
        .padding(.vertical, Constants.Spacing.small)
        .padding(.horizontal, Constants.Spacing.medium)
        .contentShape(Rectangle())
    }
} 
