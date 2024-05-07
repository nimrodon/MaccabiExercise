//
//  ProductsViewModel.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

typealias CategoryName = String

final class ProductsViewModel: ObservableObject {
    
    private var productsService: ProductsServiceProtocol
    
    @Published private(set) var isDataReady = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var showRetryButton = false

    @Published private(set) var productsDisplayModel: [CategoryName: [ProductDisplayModel]] = [:]
    @Published private(set) var categoriesDisplayModel: [CategoryDisplayModel] = []
    
    
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
    
    
    private func buildDisplayModels(products: [Product]) {

        var categoriesDisplayModelDict: [CategoryName: CategoryDisplayModel] = [:]
        var categoryCounter = 0
        
        for product in products {
            if !productsDisplayModel.keys.contains(product.category) {
                productsDisplayModel[product.category] = []
                categoryCounter += 1
                categoriesDisplayModelDict[product.category] = CategoryDisplayModel(name: product.category,
                                                                                    thumbnailURL: product.thumbnail,
                                                                                    distinctProductsCount: 1,
                                                                                    productsInStockCount: product.stock,
                                                                                    order: categoryCounter)
            }
            else {
                categoriesDisplayModelDict[product.category]?.distinctProductsCount += 1
                categoriesDisplayModelDict[product.category]?.productsInStockCount += product.stock
            }
            
            let productDisplayModel = ProductDisplayModel(name: product.title,
                                                          imageURLs: product.images,
                                                          price: product.price,
                                                          stockCount: product.stock)
            productsDisplayModel[product.category]?.append(productDisplayModel)
        }
        
        categoriesDisplayModel = categoriesDisplayModelDict.values.sorted { $0.order < $1.order }
    }
}
