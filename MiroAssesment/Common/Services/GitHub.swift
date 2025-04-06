import Foundation

/// Protocol defining the GitHub API service requirements
public protocol GithubServiceProtocol {
    /// Fetches a GitHub user by username
    /// - Parameter username: The GitHub username to fetch
    /// - Returns: A GitHubUser object with the user's profile information
    func fetchUser(username: String) async throws -> GitHubUser
    
    /// Fetches a list of a user's followers
    /// - Parameters:
    ///   - username: The GitHub username whose followers to fetch
    ///   - page: The page number to fetch (starting with 1)
    ///   - perPage: Number of results per page (default is 30)
    /// - Returns: An array of GitHubUserPreview objects representing the user's followers
    func fetchUserFollowers(username: String, page: Int, perPage: Int) async throws -> [GitHubUserPreview]
    
    /// Fetches a list of users that a specific user follows
    /// - Parameters:
    ///   - username: The GitHub username whose following list to fetch
    ///   - page: The page number to fetch (starting with 1)
    ///   - perPage: Number of results per page (default is 30)
    /// - Returns: An array of GitHubUserPreview objects representing the users being followed
    func fetchUserFollowing(username: String, page: Int, perPage: Int) async throws -> [GitHubUserPreview]
}

// Helper extensions for GithubServiceProtocol
public extension GithubServiceProtocol {
    /// Convenience method to fetch followers with default pagination
    func fetchFollowers(username: String) async throws -> [UserPreview] {
        try await fetchUserFollowers(username: username, page: 1, perPage: 30)
    }
    
    /// Convenience method to fetch following with default pagination
    func fetchFollowing(username: String) async throws -> [UserPreview] {
        try await fetchUserFollowing(username: username, page: 1, perPage: 30)
    }
}

/// Enum representing GitHub API endpoints
public enum GitHubEndpoint {
    case user(username: String)
    case followers(username: String, page: Int, perPage: Int)
    case following(username: String, page: Int, perPage: Int)
    
    /// The path component of the endpoint URL
    var path: String {
        switch self {
        case .user(let username):
            return "/users/\(username)"
        case .followers(let username, let page, let perPage):
            return "/users/\(username)/followers?page=\(page)&per_page=\(perPage)"
        case .following(let username, let page, let perPage):
            return "/users/\(username)/following?page=\(page)&per_page=\(perPage)"
        }
    }
}

/// Implementation of GithubServiceProtocol that communicates with the GitHub API
public final class GithubService: GithubServiceProtocol {
    // MARK: - Properties
    
    private let baseURL = "https://api.github.com"
    private let networkManager: NetworkManaging
    
    // MARK: - Initialization
    
    /// Initialize a GithubService with an optional NetworkManager
    /// - Parameter networkManager: Network manager to use for API requests
    public init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: - Public API
    
    public func fetchUser(username: String) async throws -> GitHubUser {
        try await request(endpoint: .user(username: username))
    }
    
    public func fetchUserFollowers(username: String, page: Int = 1, perPage: Int = 30) async throws -> [GitHubUserPreview] {
        try await request(endpoint: .followers(username: username, page: page, perPage: perPage))
    }
    
    public func fetchUserFollowing(username: String, page: Int = 1, perPage: Int = 30) async throws -> [GitHubUserPreview] {
        try await request(endpoint: .following(username: username, page: page, perPage: perPage))
    }
    
    // MARK: - Private Methods
    
    private func request<T: Decodable>(endpoint: GitHubEndpoint) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint.path)") else {
            throw NetworkError.invalidURL
        }
        
        do {
            return try await networkManager.request(url: url)
        } catch let error as NetworkError {
            // Add more specific handling for GitHub-specific errors
            switch error {
            case .httpError(let statusCode):
                switch statusCode {
                case 401:
                    // Authentication required
                    throw NetworkError.httpError(statusCode: statusCode)
                case 403:
                    // Rate limit or permission issue
                    throw NetworkError.rateLimitExceeded
                case 404:
                    // User not found
                    throw NetworkError.userNotFound
                case 422:
                    // Validation failed
                    throw NetworkError.invalidResponse
                default:
                    throw error
                }
            default:
                throw error
            }
        } catch {
            throw NetworkError.unknownError(error)
        }
    }
} 
