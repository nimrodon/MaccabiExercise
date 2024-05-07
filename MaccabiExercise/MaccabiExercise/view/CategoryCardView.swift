//
//  CategoryCardView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

struct CategoryCardView: View {
    
    var category: CategoryDisplayModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.3))
            VStack {
                Text(category.name)
                    .font(.largeTitle)
                
                AsyncImage(url: URL(string: category.thumbnailURL)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Text("Loading image...")
                }
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
            
                Spacer(minLength: 30)

                Text("Number of products: \(category.distinctProductsCount)")
                
                Text("Items in stock: \(category.productsInStockCount)")
            }
            .padding()
        }
        .frame(height:340)
        
    }

}

#Preview {
    CategoryCardView(category: CategoryDisplayModel(name: "Laptops", thumbnailURL: "https://cdn.dummyjson.com/product-images/6/thumbnail.png", distinctProductsCount: 5, productsInStockCount: 145, order: 1))
}
