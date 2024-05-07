//
//  ProductCacheServiceProtocol.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 07/05/2024.
//

import Foundation

protocol ProductsCacheServiceProtocol {
 
    func cacheProducts(products: [Product])

    func getCachedProducts() -> [Product]?

    func getLastCachingTime() -> Date?

}
