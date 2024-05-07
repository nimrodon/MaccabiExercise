//
//  ProductsServiceProtocol.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

/*
 
 A protocol defining the interface for a products service, which provides methods for fetching products asynchronously.
 
 */

protocol ProductsServiceProtocol {
    
    /*
       Fetches a list of products asynchronously.
       
       - Returns: An array of `Product` objects representing the products.
       - Throws: An error if the operation fails.
    */
    func getProducts() async throws -> [Product]
}


