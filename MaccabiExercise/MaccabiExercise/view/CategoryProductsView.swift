//
//  CategoryProductsView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

struct CategoryProductsView: View {
    
    var categoryName: String
    var products: [ProductDisplayModel]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(products.indices, id: \.self) { index in
                    ProductView(product: products[index])
                }
            }
        }
        .navigationTitle(categoryName)
    }
}

#Preview {
    CategoryProductsView(categoryName: "Cellphones", products: [
        ProductDisplayModel(name: "iphone 12", imageURLs: ["https://cdn.dummyjson.com/product-images/26/thumbnail.jpg"], price: 799, stockCount: 174),
        ProductDisplayModel(name: "iphone 15", imageURLs: ["https://cdn.dummyjson.com/product-images/26/thumbnail.jpg"], price: 899, stockCount: 83)
    ])
}
