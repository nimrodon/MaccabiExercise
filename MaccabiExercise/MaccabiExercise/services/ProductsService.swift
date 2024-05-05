//
//  ProductsService.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation


enum ProductsServiceError : Error {
    case networkError
    case parsingError
    case unknownError
}


class ProductsService : ProductsServiceProtocol {
 
    let apiEndPoint = "https://dummyjson.com/products?limit=100"
    
    func getProductsData() async throws -> [Product] {
        
        guard let url = URL(string: apiEndPoint) else {
            return []
        }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ProductsServiceError.unknownError
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ProductsServiceError.networkError
        }
        do {
            let productsQueryResponse = try JSONDecoder().decode(ProductsQueryResponse.self, from: data)
            return productsQueryResponse.products
        } catch {
            throw ProductsServiceError.parsingError
        }
    }
}
