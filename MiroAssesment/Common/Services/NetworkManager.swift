import Foundation

/// Protocol defining network management functionality
public protocol NetworkManaging {
    /// Performs a network request and returns the decoded data
    /// - Parameter url: The URL to perform the request to
    /// - Returns: The decoded response of type T
    func request<T: Decodable>(url: URL) async throws -> T
}

/// Implementation of NetworkManaging that handles API requests
public final class NetworkManager: NetworkManaging {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    /// Initialize a NetworkManager with optional custom URLSession and JSONDecoder
    /// - Parameters:
    ///   - session: URLSession to use for network requests (defaults to .shared)
    ///   - decoder: JSONDecoder to use for response decoding (defaults to new instance)
    public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
        
        // Configure the decoder for GitHub API responses (snake_case)
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    /// Performs a network request and returns the decoded data
    /// - Parameter url: The URL to perform the request to
    /// - Returns: The decoded response of type T
    public func request<T: Decodable>(url: URL) async throws -> T {
        #if DEBUG
        print("Requesting: \(url.absoluteString)")
        #endif
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 404:
                throw NetworkError.userNotFound
            case 403:
                if httpResponse.value(forHTTPHeaderField: "X-RateLimit-Remaining") == "0" {
                    throw NetworkError.rateLimitExceeded
                }
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            case 408:
                throw NetworkError.requestTimeout
            case 429:
                throw NetworkError.rateLimitExceeded
            default:
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                #if DEBUG
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response for \(url.absoluteString): \(jsonString)")
                }
                #endif

                return try decoder.decode(T.self, from: data)
            } catch {
                #if DEBUG
                print("Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found: \(context.debugDescription)")
                        print("CodingPath: \(context.codingPath)")
                    case .valueNotFound(let type, let context):
                        print("Value '\(type)' not found: \(context.debugDescription)")
                        print("CodingPath: \(context.codingPath)")
                    case .typeMismatch(let type, let context):
                        print("Type '\(type)' mismatch: \(context.debugDescription)")
                        print("CodingPath: \(context.codingPath)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                        print("CodingPath: \(context.codingPath)")
                    @unknown default:
                        print("Unknown decoding error: \(decodingError)")
                    }
                }
                #endif
                
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.networkConnectionIssue
            case .timedOut:
                throw NetworkError.requestTimeout
            case .cancelled:
                throw NetworkError.requestCancelled
            default:
                throw NetworkError.unknownError(error)
            }
        } catch {
            throw NetworkError.unknownError(error)
        }
    }
} 
