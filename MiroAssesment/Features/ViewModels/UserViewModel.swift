import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published private(set) var state: UserState = .idle
    
    private let githubService: GithubServiceProtocol
    
    init(githubService: GithubServiceProtocol = GithubService()) {
        self.githubService = githubService
    }
    
    @MainActor
    func fetchUser(username: String) async {
        if case .loading = state { return }
        
        state = .loading
        
        do {
            let user = try await githubService.fetchUser(username: username)
            state = .loaded(user)
        } catch let error as NetworkError {
            state = .error(error)
        } catch {
            state = .error(.unknownError(error))
        }
    }
    
    var user: User? {
        if case .loaded(let user) = state {
            return user
        }
        return nil
    }
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var error: NetworkError? {
        if case .error(let error) = state {
            return error
        }
        return nil
    }
} 
