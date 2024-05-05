//
//  ProductModel.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

// API data

struct Product: Codable {
    let id: Int
    let title: String
    let category: String
    let thumbnail: String
    let images: [String]
    let price: Int
    let stock: Int
}

struct ProductsQueryResponse: Codable {
    let products: [Product]
}


// App data

struct CategoryDisplayModel {
    let name: String
    let thumbnailURL: String
    var distinctProductsCount: Int
    var productsInStockCount: Int
    let order: Int
}

struct ProductDisplayModel {
    let name: String
    let imageURLs: [String]
    let price: Int
    let stockCount: Int
}
