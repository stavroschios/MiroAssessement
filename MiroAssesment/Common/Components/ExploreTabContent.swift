import SwiftUI

struct ExploreTabContent: View {
    let searchHistory: [String]
    let starredProfiles: [String]
    let onNavigateToUser: (String) -> Void
    let onClearHistory: () -> Void
    
    var body: some View {
        VStack(spacing: Constants.Spacing.large) {
            if !searchHistory.isEmpty {
                RecentUsersHorizontalList(
                    searchHistory: searchHistory,
                    onNavigateToUser: onNavigateToUser,
                    onClearHistory: onClearHistory
                )
            }
            
            if !starredProfiles.isEmpty {
                StarredProfilesList(
                    starredProfiles: starredProfiles,
                    onNavigateToUser: onNavigateToUser
                )
            }
            
            ActivityFeedSection()
        }
    }
} 
