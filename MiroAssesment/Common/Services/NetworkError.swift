import Foundation
import Combine

enum UserState {
    case idle
    case loading
    case loaded(User)
    case error(NetworkError)
}

/// Represents networking errors that can occur during API requests
public enum NetworkError: Error, LocalizedError {
    /// The provided URL is invalid
    case invalidURL
    
    /// Server returned an invalid response
    case invalidResponse
    
    /// Server responded with an HTTP error code
    case httpError(statusCode: Int)
    
    /// Requested user was not found
    case userNotFound
    
    /// GitHub API rate limit has been exceeded
    case rateLimitExceeded
    
    /// Request timed out
    case requestTimeout
    
    /// Request was cancelled
    case requestCancelled
    
    /// Network connection issue
    case networkConnectionIssue
    
    /// Error occurred during data decoding
    case decodingError(Error)
    
    /// Unknown error occurred
    case unknownError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)."
        case .userNotFound:
            return "The requested user was not found."
        case .rateLimitExceeded:
            return "GitHub API rate limit exceeded. Please try again later."
        case .requestTimeout:
            return "The request timed out."
        case .requestCancelled:
            return "The request was cancelled."
        case .networkConnectionIssue:
            return "Unable to connect to the server. Please check your internet connection."
        case .decodingError:
            return "Failed to decode the response data."
        case .unknownError(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidURL, .invalidResponse, .decodingError, .unknownError:
            return "Please try again or contact support if the problem persists."
        case .httpError(let statusCode):
            if statusCode >= 500 {
                return "Server error. Please try again later."
            } else {
                return "Please check your request and try again."
            }
        case .userNotFound:
            return "The GitHub username you entered doesn't exist. Please check the spelling and try again."
        case .networkConnectionIssue:
            return "Please check your Wi-Fi or cellular data connection and try again."
        case .requestCancelled:
            return nil
        case .rateLimitExceeded:
            return "GitHub limits the number of requests. Please wait a minute before trying again."
        case .requestTimeout:
            return "Your connection might be unstable. Please try again when you have a better connection."
        }
    }
}
