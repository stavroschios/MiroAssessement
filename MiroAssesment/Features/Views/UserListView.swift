import SwiftUI

struct UserListView: View {
    let username: String
    let listType: UserListType
    
    @StateObject private var viewModel: UserListViewModel
    
    init(username: String, listType: UserListType) {
        self.username = username
        self.listType = listType
        
        _viewModel = StateObject(wrappedValue: UserListViewModel(
            username: username,
            listType: listType
        ))
    }

    var content: some View {
        Group {
            switch viewModel.state {
            case .idle:
                EmptyView()

            case .loading:
                UserListSkeleton()

            case .loaded(let users):
                if users.isEmpty {
                    noUsersView
                } else {
                    usersList
                }

            case .error(let error):
                if let networkError = error as? NetworkError {
                    ErrorView(error: networkError) {
                        Task {
                            await viewModel.fetchUsers()
                        }
                    }
                } else {
                    ErrorView(error: NetworkError.unknownError(error)) {
                        Task {
                            await viewModel.fetchUsers()
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        ZStack {
            Constants.Colors.primaryBackground
                .ignoresSafeArea()
            content

        }
        .navigationTitle(listType.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchUsers()
        }
        .refreshable {
            await viewModel.refreshUsers()
        }
        .preferredColorScheme(.dark)
    }
    
    private var noUsersView: some View {
        VStack(spacing: Constants.Spacing.large) {
            Image(systemName: listType.emptyStateIcon)
                .font(.system(size: 50))
                .foregroundColor(Constants.Colors.secondaryText)
            
            Text(listType == .followers ? "No Followers" : "Not Following Anyone")
                .font(.system(size: Constants.FontSize.large, weight: .medium))
                .foregroundColor(Constants.Colors.primaryText)
            
            Text(listType.emptyStateTitle(username: username))
                .font(.system(size: Constants.FontSize.medium))
                .foregroundColor(Constants.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var usersList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                HStack {
                    Text("\(viewModel.totalUserCount) \(listType.title)")
                        .font(.system(size: Constants.FontSize.small, weight: .semibold))
                        .foregroundColor(Constants.Colors.secondaryText)
                    
                    Spacer()
                    
                    if viewModel.currentPage > 1 {
                        Text("Showing \(viewModel.users.count) of \(viewModel.totalUserCount)")
                            .font(.system(size: Constants.FontSize.small, weight: .semibold))
                            .foregroundColor(Constants.Colors.accent)
                    }
                }
                .padding(.horizontal, Constants.Spacing.medium)
                .padding(.top, Constants.Spacing.medium)
                
                VStack(spacing: .zero) {
                    ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
                        NavigationLink(destination: UserProfileView(username: user.login)) {
                            UserPreviewRow(user: user)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if index < viewModel.users.count - 1 {
                            Divider()
                                .background(Constants.Colors.divider)
                                .padding(.horizontal)
                        }
                    }
                    
                    if viewModel.hasMoreContent {
                        Button(action: {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }) {
                            if viewModel.isLoadingMore {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Load More")
                                    .font(.system(size: Constants.FontSize.medium, weight: .medium))
                                    .foregroundColor(Constants.Colors.accent)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .disabled(viewModel.isLoadingMore)
                        .padding(.top, Constants.Spacing.medium)
                    }
                }
                .lightCardStyle()
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .scrollIndicators(.visible)
        .scrollDismissesKeyboard(.immediately)
    }
} 
