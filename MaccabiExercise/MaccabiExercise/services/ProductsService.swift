//
//  ProductsService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

class ProductsService : ProductsServiceProtocol {
 
    let apiEndPoint = "https://dummyjson.com/products?limit=100"
    
    var cacheService: ProductsCacheServiceProtocol?

    let cachingPeriodInSeconds: TimeInterval = 3600

    
    init() {
        cacheService = ProductsFileCacheService()
    }

    
    func getProducts() async throws -> [Product] {
        
        let currentTime = Date()
        
        if let lastCachingTime = cacheService?.getLastCachingTime(),
           currentTime.timeIntervalSince(lastCachingTime) < cachingPeriodInSeconds,
           let cachedProducts = cacheService?.getCachedProducts()
        {
            return cachedProducts
        }
        else {
            return try await getProductsFromAPI()
        }
    }
    
    
    func getProductsFromAPI() async throws -> [Product] {
        
        guard let url = URL(string: apiEndPoint) else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest(url: url)
        do {

            let productsQueryResponse = try await NetworkRequestHelper.fetchJSON(ProductsQueryResponse.self, from: request)
            cacheService?.cacheProducts(products: productsQueryResponse.products)
            return productsQueryResponse.products

        } catch let networkError as NetworkError {

            print("*** ProductsService => NetworkError: \(networkError.description)")
            throw networkError

        } catch {

            print("*** ProductsService => Unknown Error: \(error.localizedDescription)")
            throw NetworkError.unknown(description: error.localizedDescription)

        }
    }


}
