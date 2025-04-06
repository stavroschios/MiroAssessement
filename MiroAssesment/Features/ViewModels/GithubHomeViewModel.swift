import Foundation
import Combine
import SwiftUI

class GithubHomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isSearchActive = false
    @Published var searchHistory: [String] = []
    @Published var recommendedUsers: [RecommendedUser] = []
    @Published var isLoading = false
    @Published var navigationPath = NavigationPath()
    @Published var starredProfiles: [String] = []
    @Published var selectedTab = 0
    
    let tabs = ["Explore", "Discover"]
    
    private let userDefaults = UserDefaults.standard
    private let historyKey = "searchHistory"
    private let starredProfilesKey = "starredProfiles"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSearchHistory()
        loadStarredProfiles()
        loadMockData()
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.isSearchActive = true
            }
            .store(in: &cancellables)
            
        // observer for starred profiles changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleStarredProfilesChanged),
            name: Notification.Name("StarredProfilesChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleStarredProfilesChanged() {
        loadStarredProfiles()
    }
    
    func addToHistory(username: String) {
        if !username.isEmpty && !searchHistory.contains(username) {
            searchHistory.insert(username, at: 0)
            
            if searchHistory.count > 10 {
                searchHistory = Array(searchHistory.prefix(10))
            }
            
            saveSearchHistory()
        }
    }
    
    func clearHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }
    
    func refreshData() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.loadMockData()
            self.loadStarredProfiles()
            self.isLoading = false
        }
    }
    
    func performSearch(query: String) {
        guard !query.isEmpty else { return }
        
        let trimmedText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        addToHistory(username: trimmedText)
        navigationPath.append(trimmedText)
        searchText = ""
        isSearchActive = false
    }
    
    private func saveSearchHistory() {
        userDefaults.set(searchHistory, forKey: historyKey)
    }
    
    private func loadSearchHistory() {
        if let history = userDefaults.stringArray(forKey: historyKey) {
            searchHistory = history
        }
    }
    
    func loadStarredProfiles() {
        starredProfiles = userDefaults.stringArray(forKey: starredProfilesKey) ?? []
    }

    // Might be mock data but they are actual users we can navigate to 
    private func loadMockData() {
        recommendedUsers = [
            RecommendedUser(username: "torvalds", avatarUrl: "https://avatars.githubusercontent.com/u/1024025", bio: "Creator of Linux and Git"),
            RecommendedUser(username: "gaearon", avatarUrl: "https://avatars.githubusercontent.com/u/810438", bio: "Working on React"),
            RecommendedUser(username: "yyx990803", avatarUrl: "https://avatars.githubusercontent.com/u/499550", bio: "Creator of Vue.js"),
            RecommendedUser(username: "dhh", avatarUrl: "https://avatars.githubusercontent.com/u/2741", bio: "Creator of Ruby on Rails"),
            RecommendedUser(username: "pjhyett", avatarUrl: "https://avatars.githubusercontent.com/u/3", bio: "GitHub co-founder")
        ]
    }
} 
