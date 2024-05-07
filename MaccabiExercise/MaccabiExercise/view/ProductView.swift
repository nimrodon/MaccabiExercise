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

            AsyncImage(url: URL(string: product.imageURLs[0])) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 150)
                    .cornerRadius(8)
                    .padding(.bottom, 8)

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
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 1))
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
    
   
}

#Preview {
    ProductView(product: ProductDisplayModel(name: "new arrivals Fashion motocross", imageURLs: ["https://cdn.dummyjson.com/product-images/99/thumbnail.jpg"], price: 46, stockCount: 138))
}
