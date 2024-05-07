//
//  NetworkRequestHelper.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 06/05/2024.
//

import Foundation

/*
 
 A helper class for making asynchronous network requests and handling network-related errors.
 
 */

class NetworkRequestHelper {
    
    /*
     Fetches and decodes JSON data from the provided URLRequest.
     
     - Parameters:
        - type: The type of the object to decode the JSON data into.
        - request: The URLRequest to fetch JSON data from.
     - Returns: A decoded object of the specified type.
     - Throws: An error of type `NetworkError` if fetching or parsing JSON data fails.
    */
    static func fetchJSON<T: Decodable>(_ type: T.Type, from request: URLRequest) async throws -> T {
        let data = try await fetchData(for: request)
        do {
            let parsedJSON = try JSONDecoder().decode(T.self, from: data)
            return parsedJSON
        } catch {
            throw NetworkError.parsingFailure(description: error.localizedDescription)
        }
    }

    
    /*
     Determines whether a network request should be retried based on the given error.
     
     - Parameter error: The network error that occurred.
     - Returns: A Boolean value indicating whether the request should be retried.
    */
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
    
    
    /*
     Fetches data from the provided URLRequest with optional retry mechanism.
     
     - Parameters:
        - request: The URLRequest to fetch data from.
        - maxRetries: The maximum number of retry attempts (default is 3).
        - retryDelay: The delay between retry attempts in seconds (default is 1.0).
     - Returns: The fetched data.
     - Throws: An error of type `NetworkError` if fetching data fails after retry attempts.
    */
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
    
    
    /*
    Maps the given error to a corresponding `NetworkError`.

    - Parameter error: The error to be mapped.
    - Returns: A `NetworkError` instance corresponding to the given error.
    */
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
