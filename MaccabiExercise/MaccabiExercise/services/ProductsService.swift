//
//  ProductsService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

/*
 
 A service for managing product data.
 
 */

class ProductsService : ProductsServiceProtocol {
 
    // The URL of the API endpoint for retrieving product data.
    let apiEndPoint = "https://dummyjson.com/products?limit=100"
    
    // An optional cache service for storing product data locally.
    let cacheService: ProductsCacheServiceProtocol?

    // The duration (in seconds) for which cached product data remains valid.
    let cachingPeriodInSeconds: TimeInterval = 3600

    
    init() {
        cacheService = ProductsFileCacheService()
    }

    
    /*
     Retrieves product data, either from the cache or the API.
     
     - Returns: An array of `Product` objects.
     - Throws: Any errors encountered during the retrieval process.
    */
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
    
    
    /*
     Fetches product data from the remote API endpoint.

     - Returns: An array of `Product` objects retrieved from the API.
     - Throws: Any network-related errors encountered during the API request.
    */
    private func getProductsFromAPI() async throws -> [Product] {
        
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
