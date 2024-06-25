//
//  ProductModel.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

// API Data Structures:

// Represents a product retrieved from the API
struct Product: Codable {
    
    // The unique identifier of the product
    let id: Int
    
    // The title or name of the product
    let title: String
    
    // The category of the product
    let category: String
    
    // The URL string to the thumbnail image of the product
    let thumbnail: String
    
    // URLs to full images of the product
    let images: [String]
    
    // The price of the product
    let price: Double
    
    // The stock count of the product
    let stock: Int
}

struct ProductsQueryResponse: Codable {
    let products: [Product]
}



// App Data Structures:

// Represents a category for display in the app
struct CategoryDisplayModel {
    
    // The name of the category
    let name: String
    
    // The URL string to the thumbnail image representing the category
    let thumbnailURL: String
    
    // The number of distinct products in this category
    var distinctProductsCount: Int
    
    // The number of products in stock for this category (total accumulated from all disticnt products)
    var productsInStockCount: Int
    
    // The order in which this category should be displayed
    let order: Int
}


// Represents a product for display in the app
struct ProductDisplayModel {
    
    // The name of the product
    let name: String
    
    // URLs or paths to images of the product
    let imageURL: String
    
    // The price of the product
    let price: Double
    
    // The stock count of the product
    let stockCount: Int
}
