//
//  ProductsFileCacheService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 07/05/2024.
//

import Foundation

/*
 
 A file-based cache service for storing and retrieving product data.
 
*/
class ProductsFileCacheService: ProductsCacheServiceProtocol {
    
    let cacheFileName = "cachedProducts.json"
    
    /*
     Caches the provided products to a JSON file.
     - Parameter products: An array of `Product` objects to be cached.
    */
    func cacheProducts(products: [Product]) {
        guard let cacheURL = cacheURL() else { return }

        do {
            let data = try JSONEncoder().encode(products)
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            print("Failed to save products to cache file: \(error.localizedDescription)")
        }
    }

    
    /*
]    Retrieves cached products from the JSON file.
    - Returns: An optional array of `Product` objects if cached data exists, otherwise `nil`.
    */
    func getCachedProducts() -> [Product]? {
        guard let cacheURL = cacheURL() else { return nil }
            
        do {
            let data = try Data(contentsOf: cacheURL)
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            print("Failed to fetch cached products: \(error.localizedDescription)")
            return nil
        }
    }

    
    /*
     Retrieves the modification date of the cache file.
     - Returns: An optional `Date` representing the time when the products were last cached, otherwise `nil`.
    */
    func getLastCachingTime() -> Date? {
        guard let cacheURL = cacheURL(),
              let attributes = try? FileManager.default.attributesOfItem(atPath: cacheURL.path),
              let modificationDate = attributes[.modificationDate] as? Date
        else {
            return nil
        }
        return modificationDate
    }

    
    /*
     Constructs the URL for the cache file in the document directory.
     - Returns: The URL of the cache file.
     */
    private func cacheURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(cacheFileName)
    }
}
