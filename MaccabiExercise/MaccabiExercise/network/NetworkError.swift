//
//  NetworkError.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 06/05/2024.
//

import Foundation
    
/*
 
 An enumeration representing various network-related errors that may occur during network operations.

 This enum conforms to `Error` protocol and `CustomStringConvertible` protocol, allowing it to be used for error handling and printing error descriptions.

 */


enum NetworkError: Error, CustomStringConvertible {
    
    //  Indicates no internet connection is available
    case noInternet
    
    //Indicates an HTTP error with the provided status code and description
    case httpFailure(statusCode: Int, description: String)

    // Indicates an error occurred while parsing data, with the provided description
    case parsingFailure(description: String)
    
    //Indicates an invalid URL was provided
    case invalidURL

    //Indicates an error occurred with the URLSession, with the provided description
    case urlSessionError(description: String)

    // Indicates an unknown error occurred, with the provided description
    case unknown(description: String)

    
    var description: String {
        switch self {
            case .noInternet:
                return "No Internet Connection"
            case .httpFailure(let statusCode, let description):
                return "HTTP Error \(statusCode): \(description)"
            case .parsingFailure(let description):
                return "Parsing Error: \(description)"
            case .invalidURL:
                return "Invalid URL"
            case .urlSessionError(let description):
                return "URLSession Error: \(description)"
            case .unknown(let description):
                return "Unknown Error: \(description)"
        }
    }
}
