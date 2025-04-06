import SwiftUI

struct GitHubHomeContent: View {
    let isLoading: Bool
    @Binding var selectedTab: Int
    let searchHistory: [String]
    let starredProfiles: [String]
    let recommendedUsers: [RecommendedUser]
    let tabs: [String]
    let onNavigateToUser: (String) -> Void
    let onClearHistory: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.Spacing.large) {

                TabNavigationBar(tabs: tabs, selectedTab: $selectedTab)
                
                if isLoading {
                    ProgressView()
                        .padding(.vertical, Constants.Spacing.extraLarge)
                } else {
                    switch selectedTab {
                    case 0:
                        ExploreTabContent(
                            searchHistory: searchHistory,
                            starredProfiles: starredProfiles,
                            onNavigateToUser: onNavigateToUser,
                            onClearHistory: onClearHistory
                        )
                    case 1:
                        DiscoverTabContent(
                            recommendedUsers: recommendedUsers,
                            onNavigateToUser: onNavigateToUser
                        )
                    default:
                        ExploreTabContent(
                            searchHistory: searchHistory,
                            starredProfiles: starredProfiles,
                            onNavigateToUser: onNavigateToUser,
                            onClearHistory: onClearHistory
                        )
                    }
                }
            }
        }
    }
} 
