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
 
    func getProducts() -> AnyPublisher<[Product], Error> {
        let currentTime = Date()
        
        if let lastCachingTime = cacheService?.getLastCachingTime(),
           currentTime.timeIntervalSince(lastCachingTime) < cachingPeriodInSeconds,
           let cachedProducts = cacheService?.getCachedProducts()
        {
            return Just(cachedProducts)
                .setFailureType(to: Error.self)
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
    private func getProductsFromAPI() -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: apiEndPoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        let request = URLRequest(url: url)
        
        return NetworkRequestHelper.fetchJSON(ProductsQueryResponse.self, from: request)
            .map { productsQueryResponse in
                self.cacheService?.cacheProducts(products: productsQueryResponse.products)
                return productsQueryResponse.products
            }
            .catch { networkError -> AnyPublisher<[Product], Error> in
//                if let networkError = error as? NetworkError {
                    print("*** ProductsService => NetworkError: \(networkError.description)")
                    return Fail(error: networkError).eraseToAnyPublisher()
//                } else {
//                    let unknownError = NetworkError.unknown(description: error.localizedDescription)
//                    print("*** ProductsService => Unknown Error: \(unknownError.description)")
//                    return Fail(error: unknownError).eraseToAnyPublisher()
//                }
            }
            .eraseToAnyPublisher()
    }
    
}
