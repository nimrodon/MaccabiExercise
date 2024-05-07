//
//  ContentView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

struct CategoriesView: View {
    
    @EnvironmentObject var viewModel: ProductsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.categoriesDisplayModel.indices, id: \.self) { index in
                            
                            let category: CategoryDisplayModel = viewModel.categoriesDisplayModel[index]
                            let products: [ProductDisplayModel] = viewModel.productsDisplayModel[category.name] ?? []
                            
                            NavigationLink (destination: CategoryProductsView(categoryName: category.name, products: products))  {
                                CategoryView(category: category)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Categories")
        }
    }
}

#Preview {
    CategoriesView()
}
