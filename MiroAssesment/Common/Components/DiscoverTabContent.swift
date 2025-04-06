import SwiftUI

struct DiscoverTabContent: View {
    let recommendedUsers: [RecommendedUser]
    let onNavigateToUser: (String) -> Void
    
    var body: some View {
        VStack(spacing: Constants.Spacing.large) {
            DevelopersToFollowSection(
                recommendedUsers: recommendedUsers,
                onNavigateToUser: onNavigateToUser
            )
            
            InspirationQuoteCard()
        }
    }
}
