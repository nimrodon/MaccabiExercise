//
//  NetworkRequestHelper.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 06/05/2024.
//

import Foundation

class NetworkRequestHelper {
    
    static func fetchJSON<T: Decodable>(_ type: T.Type, from request: URLRequest) async throws -> T {
        let data = try await fetchData(for: request)
        do {
            let parsedJSON = try JSONDecoder().decode(T.self, from: data)
            return parsedJSON
        } catch {
            throw NetworkError.parsingFailure(description: error.localizedDescription)
        }
    }

    
    public static func shouldRetryRequest(for error: NetworkError) -> Bool {
        switch error {
            case .noInternet, .urlSessionError:
                return true
            case .httpFailure(let statusCode, _):
                return (500...599).contains(statusCode) || statusCode == 429
            default:
                return false
            }
    }
    
    
    private static func fetchData(for request: URLRequest, maxRetries: Int = 3, retryDelay: TimeInterval = 1.0) async throws -> Data {
        
        var retries = 0
        var lastError: NetworkError?
        
        while retries <= maxRetries {
            do {
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknown(description: "Invalid HTTP response")
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let description = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    throw NetworkError.httpFailure(statusCode: httpResponse.statusCode, description: description)
                }
                
                return data
                
            } catch {
                let networkError = mapErrorToNetworkError(error)
                
                if !shouldRetryRequest(for: networkError) || retries >= maxRetries  {
                    throw networkError
                }
                
                retries += 1
                lastError = networkError
                
                print("NetworkRequestHelper => retrying in \(retryDelay) seconds due to: \(networkError.description)")
                try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
            }
        }

        throw lastError ?? NetworkError.unknown(description: "Unknown error occurred.")
    }
    
    
    private static func mapErrorToNetworkError(_ error: Error) -> NetworkError {
       if let networkError = error as? NetworkError {
           return networkError
       } else if let urlError = error as? URLError {
           if urlError.code == .notConnectedToInternet {
               return .noInternet
           }
           else {
               return .urlSessionError(description: urlError.localizedDescription)
           }
       } else {
           return .unknown(description: error.localizedDescription)
       }
   }
    
}
