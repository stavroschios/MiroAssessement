import SwiftUI
import UIKit

struct UserProfileView: View {
    let username: String
    @StateObject private var viewModel = UserViewModel()
    @StateObject private var starredViewModel = StarredProfilesViewModel()
    @Environment(\.refresh) private var refreshAction
    
    var body: some View {
        ZStack {
            Constants.Colors.primaryBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Constants.Spacing.large) {
                    switch viewModel.state {
                    case .idle:
                        EmptyView()
                        
                    case .loading:
                        UserProfileSkeleton()
                        
                    case .loaded(let user):
                        userProfile(user: user)
                            .transition(.opacity)
                        
                    case .error(let error):
                        ErrorView(error: error) {
                            Task {
                                await viewModel.fetchUser(username: username)
                            }
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.visible)
            .scrollDismissesKeyboard(.immediately)
        }
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Constants.Colors.accent)
                }
            }
        }
        .task {
            await viewModel.fetchUser(username: username)
        }
        .refreshable {
            await viewModel.fetchUser(username: username)
        }
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private func userProfile(user: User) -> some View {
        VStack(alignment: .center, spacing: Constants.Spacing.large) {
            VStack(spacing: Constants.Spacing.medium) {
                GitHubAvatarView(username: user.login, size: Constants.ImageSize.avatar)
                
                VStack(spacing: Constants.Spacing.small) {
                    Text(user.login)
                        .font(.system(size: Constants.FontSize.extraLarge, weight: .bold))
                        .foregroundColor(Constants.Colors.primaryText)
                    
                    if let name = user.name {
                        Text(name)
                            .font(.system(size: Constants.FontSize.medium))
                            .foregroundColor(Constants.Colors.secondaryText)
                    }
                }
            }
            .padding(.bottom, Constants.Spacing.medium)
            
            if let bio = user.bio, !bio.isEmpty {
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    Text("Bio")
                        .font(.system(size: Constants.FontSize.small, weight: .semibold))
                        .foregroundColor(Constants.Colors.secondaryText)
                        .padding(.horizontal, Constants.Spacing.small)
                    
                    Text(bio)
                        .font(.system(size: Constants.FontSize.medium))
                        .foregroundColor(Constants.Colors.primaryText)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lightCardStyle()
                }
            }
            
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                Text("Stats")
                    .font(.system(size: Constants.FontSize.small, weight: .semibold))
                    .foregroundColor(Constants.Colors.secondaryText)
                    .padding(.horizontal, Constants.Spacing.small)
                
                HStack(spacing: 0) {
                    NavigationLink(destination: UserListView(username: user.login, listType: .followers)) {
                        VStack(spacing: Constants.Spacing.tiny) {
                            Text("\(user.followers)")
                                .font(.system(size: Constants.FontSize.large, weight: .bold))
                                .foregroundColor(Constants.Colors.primaryText)
                            
                            Text("Followers")
                                .font(.system(size: Constants.FontSize.small))
                                .foregroundColor(Constants.Colors.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .background(Constants.Colors.divider)
                    
                    NavigationLink(destination: UserListView(username: user.login, listType: .following)) {
                        VStack(spacing: Constants.Spacing.tiny) {
                            Text("\(user.following)")
                                .font(.system(size: Constants.FontSize.large, weight: .bold))
                                .foregroundColor(Constants.Colors.primaryText)
                            
                            Text("Following")
                                .font(.system(size: Constants.FontSize.small))
                                .foregroundColor(Constants.Colors.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .lightCardStyle()
            }
            
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                Text("Actions")
                    .font(.system(size: Constants.FontSize.small, weight: .semibold))
                    .foregroundColor(Constants.Colors.secondaryText)
                    .padding(.horizontal, Constants.Spacing.small)
                
                Button(action: {
                    withAnimation(.spring(dampingFraction: 0.7)) {
                        starredViewModel.toggleStarred(username: user.login)
                    }
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    HStack {
                        Image(systemName: starredViewModel.isStarred ? "star.fill" : "star")
                            .foregroundColor(starredViewModel.isStarred ? .yellow : Constants.Colors.accent)
                            .imageScale(.large)
                        
                        Text(starredViewModel.isStarred ? "Starred Profile" : "Star Profile")
                            .foregroundColor(Constants.Colors.primaryText)
                        
                        Spacer()
                        
                        if starredViewModel.isStarred {
                            Image(systemName: "checkmark")
                                .foregroundColor(.yellow)
                                .font(.system(size: Constants.FontSize.small))
                        } else {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Constants.Colors.secondaryText)
                                .font(.system(size: Constants.FontSize.small))
                        }
                    }
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
                .lightCardStyle()
                .onAppear {
                    _ = starredViewModel.checkIfStarred(username: user.login)
                }
            }
        }
    }
} 
