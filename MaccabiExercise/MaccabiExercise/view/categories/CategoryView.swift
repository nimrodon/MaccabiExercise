//
//  CategoryView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

struct CategoryView: View {
    
    var category: CategoryDisplayModel
    
    var body: some View {
        VStack {

            Text(category.name)
                .font(.title)

            DisplayImage(imageURL: category.thumbnailURL, width: 150, height: 150)
            
            Spacer(minLength: 30)
            
            Text("Number of products: \(category.distinctProductsCount)")
                .font(.subheadline)
            
            Text("Items in stock: \(category.productsInStockCount)")
                .font(.subheadline)
        }
        .outlineFrame()
    }

}

#Preview {
    CategoryView(category: CategoryDisplayModel(name: "Laptops", thumbnailURL: "https://cdn.dummyjson.com/product-images/26/thumbnail.jpg", distinctProductsCount: 5, productsInStockCount: 145, order: 1))
}
