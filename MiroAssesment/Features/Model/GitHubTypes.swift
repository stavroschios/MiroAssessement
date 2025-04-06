import Foundation

public typealias User = GitHubUser
public typealias UserPreview = GitHubUserPreview

/// Model representing a GitHub user profile
public struct GitHubUser: Codable, Identifiable, Equatable {
    /// The unique identifier for the user
    public let id: Int
    
    /// The user's login name (username)
    public let login: String
    
    /// The user's display name (optional)
    public let name: String?
    
    /// URL to the user's avatar image
    public let avatarUrl: String
    
    /// The user's bio description (optional)
    public let bio: String?
    
    /// Number of followers the user has
    public let followers: Int
    
    /// Number of users the user is following
    public let following: Int
    
    /// URL to the user's GitHub profile
    public let htmlUrl: String?
    
    /// The user's company (optional)
    public let company: String?
    
    /// The user's blog URL (optional)
    public let blog: String?
    
    /// The user's location (optional)
    public let location: String?
    
    /// The user's email (optional)
    public let email: String?
    
    /// The user's Twitter username (optional)
    public let twitterUsername: String?
    
    /// Flag indicating if the user is hireable (optional)
    public let hireable: Bool?
    
    /// Number of public repositories
    public let publicRepos: Int?
    
    /// Number of public gists
    public let publicGists: Int?
    
    /// Date the user was created
    public let createdAt: String?
    
    /// Date the user was last updated
    public let updatedAt: String?
    
    // We're using decoder.keyDecodingStrategy = .convertFromSnakeCase
    // so we don't need to specify CodingKeys for snake_case to camelCase conversion
    
    public static func == (lhs: GitHubUser, rhs: GitHubUser) -> Bool {
        lhs.id == rhs.id
    }
}

/// A lightweight model for a GitHub user, used in lists
public struct GitHubUserPreview: Codable, Identifiable, Equatable {
    /// The unique identifier for the user
    public let id: Int
    
    /// The user's login name (username)
    public let login: String
    
    /// URL to the user's avatar image
    public let avatarUrl: String
    
    /// Type of GitHub account (User, Organization, etc.)
    public let type: String?
    
    /// URL to the user's GitHub profile
    public let htmlUrl: String?
    
    // We're using decoder.keyDecodingStrategy = .convertFromSnakeCase
    // so we don't need to specify CodingKeys for snake_case to camelCase conversion
    
    public static func == (lhs: GitHubUserPreview, rhs: GitHubUserPreview) -> Bool {
        lhs.id == rhs.id
    }
}
