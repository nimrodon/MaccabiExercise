//
//  ProductsServiceProtocol.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 05/05/2024.
//

import Foundation

protocol ProductsServiceProtocol {
    func getProductsData() async throws -> [Product]
}


