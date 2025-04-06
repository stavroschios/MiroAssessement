import SwiftUI
import UIKit

class StarredProfilesViewModel: ObservableObject {
    @Published var isStarred: Bool = false
    private let storageKey = "starredProfiles"
    
    func checkIfStarred(username: String) -> Bool {
        let starredProfiles = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        let starred = starredProfiles.contains(username)
        isStarred = starred
        return starred
    }
    
    func toggleStarred(username: String) {
        isStarred.toggle()
        saveStarredStatus(username: username, isStarred: isStarred)
    }
    
    private func saveStarredStatus(username: String, isStarred: Bool) {
        var starredProfiles = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        
        if isStarred {
            if !starredProfiles.contains(username) {
                starredProfiles.append(username)
            }
        } else {
            starredProfiles.removeAll { $0 == username }
        }
        
        UserDefaults.standard.set(starredProfiles, forKey: storageKey)
        
        NotificationCenter.default.post(name: Notification.Name("StarredProfilesChanged"), object: nil)
    }
}
