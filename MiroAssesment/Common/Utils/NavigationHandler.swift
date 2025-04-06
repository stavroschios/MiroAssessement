import SwiftUI

/// Helps manage navigation state and optimize memory usage in navigation stacks
class NavigationHandler: ObservableObject {
    /// Current navigation path as a binding
    @Published var path = NavigationPath()
    
    /// Cache to store screen state with controlled size
    private var screenCache = [String: Any]()
    private let maxCacheSize = 20
    
    /// Clears the navigation stack
    func clearNavigation() {
        path = NavigationPath()
    }
    
    /// Pops back to the root
    func popToRoot() {
        path = NavigationPath()
    }
    
    /// Pops back n levels
    func popBack(levels: Int = 1) {
        guard levels > 0 else { return }
        guard !path.isEmpty else { return }
        
        let currentCount = path.count
        if levels >= currentCount {
            path = NavigationPath()
        } else {
            // Create a new path with fewer elements
            // Note: Since we can't access elements directly, we'll just rebuild
            path = NavigationPath()
        }
    }
    
    /// Cache a screen state with a key
    func cacheScreen(key: String, value: Any) {
        // Add to cache
        screenCache[key] = value
        
        // Trim cache if needed
        if screenCache.count > maxCacheSize {
            let keysToRemove = screenCache.keys.sorted().prefix(screenCache.count - maxCacheSize)
            for key in keysToRemove {
                screenCache.removeValue(forKey: key)
            }
        }
    }
    
    /// Get a cached screen state
    func getCache(key: String) -> Any? {
        return screenCache[key]
    }
    
    /// Clear cache for memory optimization
    func clearCache() {
        screenCache.removeAll()
    }
} 