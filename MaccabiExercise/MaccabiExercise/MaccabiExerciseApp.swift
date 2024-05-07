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
    private let viewModel: ProductsViewModel

    init() {
        print("init app")
        productsService = ProductsService()
        viewModel = ProductsViewModel(productsService)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
                .task {
                    await viewModel.fetchProducts()
                }
//                .ignoresSafeArea(edges: [])
        }
    }
}
