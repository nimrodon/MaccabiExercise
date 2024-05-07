//
//  ProductsService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

class ProductsService : ProductsServiceProtocol {
 
    let apiEndPoint = "https://dummyjson.com/products?limit=100"
    
    func getProductsData() async throws -> [Product] {
        
        guard let url = URL(string: apiEndPoint) else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest(url: url)
        do {

            let productsQueryResponse = try await NetworkRequestHelper.fetchJSON(ProductsQueryResponse.self, from: request)
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
