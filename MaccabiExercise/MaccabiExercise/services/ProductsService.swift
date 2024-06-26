//
//  ProductsService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation
import Combine
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

//    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        cacheService = ProductsFileCacheService()
    }

    
    /*
     Retrieves product data, either from the cache or the API.
     
     - Returns: An array of `Product` objects.
     - Throws: Any errors encountered during the retrieval process.
    */
 
    func getProducts() -> AnyPublisher<[Product], NetworkError> {
        let currentTime = Date()
        
        if let lastCachingTime = cacheService?.getLastCachingTime(),
           currentTime.timeIntervalSince(lastCachingTime) < cachingPeriodInSeconds,
           let cachedProducts = cacheService?.getCachedProducts()
        {
            return Just(cachedProducts)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return getProductsFromAPI()
        }
    }
    
    
    /*
     Fetches product data from the remote API endpoint.

     - Returns: An array of `Product` objects retrieved from the API.
     - Throws: Any network-related errors encountered during the API request.
    */
    private func getProductsFromAPI() -> AnyPublisher<[Product], NetworkError> {
        guard let url = URL(string: apiEndPoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        let request = URLRequest(url: url)
        
        return NetworkRequestHelper.fetchJSON(ProductsQueryResponse.self, from: request)
            .map { productsQueryResponse in
                self.cacheService?.cacheProducts(products: productsQueryResponse.products)
                return productsQueryResponse.products
            }
            .catch { error -> AnyPublisher<[Product], NetworkError> in
                    print("*** ProductsService => Error: \(error.description)")
                    return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
}
