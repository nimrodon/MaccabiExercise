//
//  CategoryCardView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

struct CategoryCardView: View {
    
    var categoryDisplayModel: CategoryDisplayModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20) // Adjust the corner radius to your preference
                .fill(Color.blue.opacity(0.3)) // Adjust opacity or color to your preference
                .frame(width: 300, height: 300) // Adjust width and height as needed
            
            VStack {
                Text(categoryDisplayModel.name)
                AsyncImage(url: URL(string: categoryDisplayModel.thumbnailURL)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Text("Loading image...")
                }
                .frame(width: 200, height: 200)
                
                Text("Number of products: \(categoryDisplayModel.distinctProductsCount)")
                Text("Items in stock: \(categoryDisplayModel.productsInStockCount)")
            }
        }
    }

}

#Preview {
    CategoryCardView(categoryDisplayModel: CategoryDisplayModel(name: "Laptops", thumbnailURL: "https://cdn.dummyjson.com/product-images/6/thumbnail.png", distinctProductsCount: 5, productsInStockCount: 145, order: 1))
}
