import Foundation
import SwiftUI
import UIKit
import os.lock

/// A robust image caching system with concurrent request handling
final class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    private let cache = NSCache<NSURL, UIImage>()
    private var runningRequests = [URL: Task<UIImage, Error>]()
    private var lock = os_unfair_lock_s()
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func removeImage(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    func fetch(_ urlString: String) async throws -> UIImage {
        guard let url = URL(
            string: urlString.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        ) else {
            throw URLError(.badURL)
        }
        return try await fetch(url)
    }

    func fetch(_ url: URL) async throws -> UIImage {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        var existingTask: Task<UIImage, Error>?
        withLock { existingTask = runningRequests[url] }
        if let existingTask = existingTask {
            do {
                return try await existingTask.value
            } catch {
                withLock { runningRequests.removeValue(forKey: url) }
                throw error
            }
        }

        let task = Task<UIImage, Error> {
            defer { withLock { runningRequests.removeValue(forKey: url) } }
            do {
                var request = URLRequest(url: url)
                request.cachePolicy = .reloadIgnoringLocalCacheData
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                cache.setObject(image, forKey: url as NSURL)
                return image
            } catch {
                print("Image loading error for URL \(url): \(error.localizedDescription)")
                throw error
            }
        }
        withLock { runningRequests[url] = task }
        return try await task.value
    }

    func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
        guard let url = urlRequest.url else {
            throw URLError(.badURL)
        }
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        var existingTask: Task<UIImage, Error>?
        withLock { existingTask = runningRequests[url] }
        if let existingTask = existingTask {
            return try await existingTask.value
        }
        let task = Task<UIImage, Error> {
            defer {
                withLock { runningRequests.removeValue(forKey: url) }
            }
            var newRequest = urlRequest
            newRequest.cachePolicy = .reloadIgnoringLocalCacheData
            let (data, response) = try await URLSession.shared.data(for: newRequest)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            cache.setObject(image, forKey: url as NSURL)
            return image
        }
        withLock { runningRequests[url] = task }
        return try await task.value
    }

    func prefetch(_ urlString: String) {
        guard let url = URL(
            string: urlString.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        ) else { return }
        if cache.object(forKey: url as NSURL) == nil {
            var shouldPrefetch = false
            withLock { shouldPrefetch = runningRequests[url] == nil }
            if shouldPrefetch {
                Task {
                    do {  _ = try await fetch(url) } catch {
                        print("Prefetch failed for URL \(url): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @discardableResult
    private func withLock<T>(_ operation: () -> T) -> T {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return operation()
    }
} 
