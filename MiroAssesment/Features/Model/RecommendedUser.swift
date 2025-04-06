import Foundation

public struct RecommendedUser: Identifiable, Equatable {
    public let id = UUID()
    public let username: String
    public let avatarUrl: String
    public let bio: String?

    public init(
        username: String,
        avatarUrl: String,
        bio: String? = nil
    ) {
        self.username = username
        self.avatarUrl = avatarUrl
        self.bio = bio
    }

    public static func == (
        lhs: RecommendedUser,
        rhs: RecommendedUser
    ) -> Bool {
        lhs.id == rhs.id
    }
} 
