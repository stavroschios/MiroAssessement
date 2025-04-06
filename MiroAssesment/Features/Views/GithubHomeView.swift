import SwiftUI

struct GithubHomeView: View {

    @StateObject private var viewModel = GithubHomeViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Constants.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Spacing.medium) {
                    GitHubSearchBar(
                        searchText: $viewModel.searchText,
                        isSearching: $viewModel.isSearchActive,
                        onSubmit: {
                            viewModel.performSearch(query: viewModel.searchText)
                        }
                    )
                    
                    if viewModel.isSearchActive && !viewModel.searchText.isEmpty {
                        SearchQueryPreviewCard(
                            searchText: viewModel.searchText,
                            onSubmit: {
                                viewModel.performSearch(query: viewModel.searchText)
                            }
                        )
                    } else {
                        GitHubHomeContent(
                            isLoading: viewModel.isLoading,
                            selectedTab: $viewModel.selectedTab,
                            searchHistory: viewModel.searchHistory,
                            starredProfiles: viewModel.starredProfiles,
                            recommendedUsers: viewModel.recommendedUsers,
                            tabs: viewModel.tabs,
                            onNavigateToUser: { username in
                                viewModel.navigationPath.append(username)
                            },
                            onClearHistory: {
                                viewModel.clearHistory()
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("GitHub")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.refreshData()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Constants.Colors.accent)
                    }
                }
            }
            .navigationDestination(for: String.self) { username in
                UserProfileView(username: username)
                    .id(username)
            }
            .refreshable {
                viewModel.refreshData()
            }
        }
        .environmentObject(NavigationHandler())
        .preferredColorScheme(.dark)
    }
} 
