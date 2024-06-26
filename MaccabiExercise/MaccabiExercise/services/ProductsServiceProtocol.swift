//
//  ProductsServiceProtocol.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation
import Combine
/*
 
 A protocol defining the interface for a products service, which provides methods for fetching products asynchronously.
 
 */

protocol ProductsServiceProtocol {
    
    /*
       Fetches a publisher of products.
       
       - Returns: A publisher that emits `Product` objects representing the products.
       - Throws: An error if the operation fails.
    */
    func getProducts() -> AnyPublisher<[Product], NetworkError>
}


