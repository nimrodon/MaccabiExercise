//
//  ProductView.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import SwiftUI

struct ProductView: View {
    
    var product: ProductDisplayModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 8) {

            AsyncImage(url: URL(string: product.imageURL)) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Text("Loading image...")
                }
                .frame(width: 200, height: 200)
                .cornerRadius(20)

            HStack {
                VStack (alignment: .leading){
                    
                    Text(product.name)
                        .font(.headline)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 10)
                    
                    Text("price: $\(product.price)")
                        .font(.subheadline)
                    
                    Text("Items in stock: \(product.stockCount)")
                        .font(.subheadline)
                }
                Spacer()
            }
            Spacer()
        }
            .cardFrame()
    }
    
   
}

#Preview {
    ProductView(product: ProductDisplayModel(name: "new arrivals Fashion motocross", imageURL: "https://cdn.dummyjson.com/product-images/26/thumbnail.jpg", price: 46, stockCount: 138))
}
