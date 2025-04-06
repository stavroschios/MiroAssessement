import SwiftUI

struct DevelopersToFollowSection: View {
    let recommendedUsers: [RecommendedUser]
    let onNavigateToUser: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            Text("Developers to Follow")
                .font(.system(size: Constants.FontSize.medium, weight: .semibold))
                .foregroundColor(Constants.Colors.primaryText)
                .padding(.horizontal, Constants.Spacing.small)
            
            VStack(spacing: 0) {
                ForEach(recommendedUsers) { user in
                    Button {
                        onNavigateToUser(user.username)
                    } label: {
                        DeveloperRowItem(user: user)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if user.id != recommendedUsers.last?.id {
                        Divider()
                            .background(Constants.Colors.divider)
                            .padding(.horizontal)
                    }
                }
            }
            .cardStyle()
        }
    }
}
