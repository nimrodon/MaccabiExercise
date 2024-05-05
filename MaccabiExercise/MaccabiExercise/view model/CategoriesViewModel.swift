//
//  CategoriesViewModel.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

typealias CategoryName = String

final class CategoriesViewModel: ObservableObject {
    
    private var productsService: ProductsServiceProtocol
    
    @Published private(set) var isDataReady = false
    @Published private(set) var exception: ProductsServiceError?
    
    @Published private(set) var productsDisplayModel: [CategoryName: [Product]] = [:]
    @Published private(set) var categoriesDisplayModel: [CategoryDisplayModel] = []
    
    
    init(_ productsService: ProductsServiceProtocol) {
        self.productsService = productsService
    }

    
    func fetchProducts() async {
//        defer { isDataReady = true }
        do {
            let products = try await productsService.getProductsData()
            DispatchQueue.main.async {
                self.buildDisplayModels(products: products)
                self.isDataReady = true
            }
        }
        catch {
            
        }
    }
    
    
    func buildDisplayModels(products: [Product]) {

        var categoriesDisplayModelDict: [CategoryName: CategoryDisplayModel] = [:]
        var categoryCounter = 0
        
        for product in products {
            if !productsDisplayModel.keys.contains(product.category) {
                categoryCounter += 1
                categoriesDisplayModelDict[product.category] = CategoryDisplayModel(name: product.category,
                                                                                    thumbnailURL: product.thumbnail,
                                                                                    distinctProductsCount: 1,
                                                                                    productsInStockCount: product.stock,
                                                                                    order: categoryCounter)
                productsDisplayModel[product.category] = []
            }
            else {
                categoriesDisplayModelDict[product.category]?.distinctProductsCount += 1
                categoriesDisplayModelDict[product.category]?.productsInStockCount += product.stock
            }
            productsDisplayModel[product.category]?.append(product)
        }
        
        categoriesDisplayModel = categoriesDisplayModelDict.values.sorted { $0.order < $1.order }
    }
}
