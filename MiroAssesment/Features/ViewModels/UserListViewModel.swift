import Foundation
import Combine
import SwiftUI

enum UserListType: String {
    case followers = "Followers"
    case following = "Following"
    
    var title: String { return rawValue }
    
    var emptyStateIcon: String {
        switch self {
        case .followers: return "person.2.slash"
        case .following: return "person.slash"
        }
    }
    
    func emptyStateTitle(username: String) -> String {
        switch self {
        case .followers: return "\(username) doesn't have any followers yet."
        case .following: return "\(username) isn't following anyone yet."
        }
    }
}

enum UserListState: Equatable {
    case idle
    case loading
    case loaded([UserPreview])
    case error(Error)
    
    static func ==(lhs: UserListState, rhs: UserListState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsUsers), .loaded(let rhsUsers)):
            return lhsUsers.map { $0.id } == rhsUsers.map { $0.id }
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

class UserListViewModel: ObservableObject {
    @Published var state: UserListState = .idle
    @Published var users: [UserPreview] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var currentPage = 1
    @Published var totalUserCount = 0
    @Published var hasMoreContent = false
    @Published var isLoadingMore = false
    
    private let service: GithubServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let username: String
    private let listType: UserListType
    private let perPage = 30
    
    init(
        username: String,
        listType: UserListType,
        service: GithubServiceProtocol = GithubService()
    ) {
        self.username = username
        self.listType = listType
        self.service = service
        
        $state
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle:
                    self.isLoading = false
                    self.error = nil
                    self.users = []
                case .loading:
                    self.isLoading = true
                    self.error = nil
                case .loaded(let users):
                    self.isLoading = false
                    self.error = nil
                    self.users = users
                case .error(let error):
                    self.isLoading = false
                    self.error = error
                    self.users = []
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchUsers() async {
        if case .loading = state {
            return
        }
        
        state = .loading
        currentPage = 1
        
        do {
            // Get user profile to get total count - this may throw
            let user = try await service.fetchUser(username: username)
            
            // Update total count based on user profile
            switch listType {
            case .followers:
                totalUserCount = user.followers
            case .following:
                totalUserCount = user.following
            }
            
            // fetch first page
            try await fetchPage(page: currentPage)
        } catch {
            state = .error(error)
        }
    }
    
    @MainActor
    func fetchPage(page: Int) async throws {
        guard !isLoadingMore else { return }
        
        isLoadingMore = true
        currentPage = page
        
        do {
            let fetchedUsers: [UserPreview]
            
            switch listType {
            case .followers:
                fetchedUsers = try await service.fetchUserFollowers(username: username, page: page, perPage: perPage)
            case .following:
                fetchedUsers = try await service.fetchUserFollowing(username: username, page: page, perPage: perPage)
            }
            
            if page == 1 {
                // Replace users for first page
                state = .loaded(fetchedUsers)
            } else {
                // Append users for subsequent pages
                appendUsers(fetchedUsers)
            }
            
            // If we received a full page, there might be more to load
            hasMoreContent = fetchedUsers.count == perPage && (page * perPage) < totalUserCount
            isLoadingMore = false
            
            // Precache avatars for better scrolling performance
            Task.detached { [weak self] in
                self?.prefetchImages(for: fetchedUsers)
            }
        } catch {
            state = .error(error)
            isLoadingMore = false
            throw error
        }
    }
    
    @MainActor
    private func appendUsers(_ newUsers: [UserPreview]) {
        if case .loaded(let existingUsers) = state {
            let combinedUsers = existingUsers + newUsers
            state = .loaded(combinedUsers)
            users = combinedUsers
        }
    }
    
    @MainActor
    func loadNextPage() async {
        guard case .loaded = state, hasMoreContent, !isLoadingMore else { return }
        
        currentPage += 1
        
        do {
            try await fetchPage(page: currentPage)
        } catch {
            #if DEBUG
            print("Failed to load next page: \(error.localizedDescription)")
            #endif
        }
    }
    
    @MainActor
    func refreshUsers() async {
        await fetchUsers()
    }
    
    private func prefetchImages(for users: [UserPreview]) {
        for user in users {
            ImageCache.shared.prefetch(user.avatarUrl)
        }
    }
} 
