//
//  MaccabiExerciseApp.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

@main
struct MaccabiExerciseApp: App {
    
    private let productsService: ProductsServiceProtocol
    private let viewModel: CategoriesViewModel

    init() {
        print("init app")
        productsService = ProductsService()
        viewModel = CategoriesViewModel(productsService)
    }

    var body: some Scene {
        WindowGroup {
            CategoriesView()
                .environmentObject(viewModel)
                .task {
                    await viewModel.fetchProducts()
                }
        }
    }
}
