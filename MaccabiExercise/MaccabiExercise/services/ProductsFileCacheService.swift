//
//  ProductsFileCacheService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 07/05/2024.
//

import Foundation

class ProductsFileCacheService: ProductsCacheServiceProtocol {
    
    let cacheFileName = "cachedProducts.json"

    func cacheProducts(products: [Product]) {
        guard let cacheURL = cacheURL() else { return }

        do {
            let data = try JSONEncoder().encode(products)
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            print("Failed to save products to cache file: \(error.localizedDescription)")
        }
    }
    

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

    
    func getLastCachingTime() -> Date? {
        guard let cacheURL = cacheURL(),
              let attributes = try? FileManager.default.attributesOfItem(atPath: cacheURL.path),
              let modificationDate = attributes[.modificationDate] as? Date
        else {
            return nil
        }
        return modificationDate
    }

    
    private func cacheURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(cacheFileName)
    }
}
