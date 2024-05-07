//
//  ProductsViewModel.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

typealias CategoryName = String

/*
 
  View model responsible for managing products data

*/

final class ProductsViewModel: ObservableObject {
    
    private var productsService: ProductsServiceProtocol
    
    @Published private(set) var isDataReady = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var showRetryButton = false

    @Published private(set) var categoriesDisplayModel: [CategoryDisplayModel] = []
    @Published private(set) var productsDisplayModel: [CategoryName: [ProductDisplayModel]] = [:]
    
    
    init(_ productsService: ProductsServiceProtocol) {
        self.productsService = productsService
    }

    
    func fetchProducts() async {
        
        do {

            let products = try await productsService.getProducts()

            DispatchQueue.main.async {
                self.buildDisplayModels(products: products)
                self.isDataReady = true
                self.errorMessage = nil
                self.showRetryButton = false
            }
            
        } catch let networkError as NetworkError {
            DispatchQueue.main.async {
                self.isDataReady = false
                self.errorMessage = networkError.description
                self.showRetryButton = NetworkRequestHelper.shouldRetryRequest(for: networkError)
            }
        } catch {
            DispatchQueue.main.async {
                self.isDataReady = false
                self.errorMessage = "Unknown error: \(error.localizedDescription)"
                self.showRetryButton = false
            }
        }
    }
    
    
    func retryFetchProducts() {
        DispatchQueue.main.async {
            self.errorMessage = nil
            self.showRetryButton = false
        }
        Task {
            await fetchProducts()
        }
    }
    
    
    /*
     Builds display models for products and categories based on the provided products.
     - Parameter products: An array of `Product` objects
    */
    private func buildDisplayModels(products: [Product]) {

        var categoriesDisplayModelDict: [CategoryName: CategoryDisplayModel] = [:]
        var categoryCounter = 0
        
        for product in products {

            // check if product's category is new:
            if !productsDisplayModel.keys.contains(product.category) {
                
                //add initial category display data
                productsDisplayModel[product.category] = []
                categoryCounter += 1
                categoriesDisplayModelDict[product.category] = CategoryDisplayModel(name: product.category,
                                                                                    thumbnailURL: product.thumbnail,
                                                                                    distinctProductsCount: 1,
                                                                                    productsInStockCount: product.stock,
                                                                                    order: categoryCounter)
            }
            else {
                // increase distinct products count for category and accumulate category stock count
                categoriesDisplayModelDict[product.category]?.distinctProductsCount += 1
                categoriesDisplayModelDict[product.category]?.productsInStockCount += product.stock
            }

            // add new product display data
            let productDisplayModel = ProductDisplayModel(name: product.title,
                                                          imageURL: product.images[0],
                                                          price: product.price,
                                                          stockCount: product.stock)
            productsDisplayModel[product.category]?.append(productDisplayModel)
        }
        
        // sort categories according to the original order they appear in producs array
        categoriesDisplayModel = categoriesDisplayModelDict.values.sorted { $0.order < $1.order }
    }
}
