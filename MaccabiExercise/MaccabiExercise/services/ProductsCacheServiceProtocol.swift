//
//  ProductCacheServiceProtocol.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 07/05/2024.
//

import Foundation

/*
 
  A protocol defining the contract for products cache services.
 
*/
protocol ProductsCacheServiceProtocol {
    
    /*
    Caches the provided products.
     
    - Parameter products: An array of `Product` objects to be cached.
    */
    func cacheProducts(products: [Product])
    
    
    /*
    Retrieves cached products.
     
    - Returns: An optional array of `Product` objects if cached data exists, otherwise `nil`.
    */
    func getCachedProducts() -> [Product]?
    
    
    /*
    Retrieves the last caching time.
     
    - Returns: An optional `Date` representing the time when the products were last cached,
      otherwise `nil`.
    */
    func getLastCachingTime() -> Date?
}
