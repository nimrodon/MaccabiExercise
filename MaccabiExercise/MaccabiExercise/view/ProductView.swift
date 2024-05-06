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
        ZStack {
            RoundedRectangle(cornerRadius: 20) // Adjust the corner radius to your preference
                .fill(Color.green.opacity(0.3)) // Adjust opacity or color to your preference
                .frame(width: 300, height: 300) // Adjust width and height as needed
            
            
            VStack {
                Text(product.name)
                AsyncImage(url: URL(string: product.imageURLs[0])) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Text("Loading image...")
                }
                .frame(width: 200, height: 200)
                
                Text("price: $\(product.price)")
                Text("Items in stock: \(product.stockCount)")
            }
        }
    }
}

//#Preview {
//    ProductView()
//}
