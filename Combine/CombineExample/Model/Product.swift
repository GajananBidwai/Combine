//
//  Product.swift
//  CombineExample
//
//  Created by Neosoft on 10/09/25.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description, category: String
    let image: String
    let rating: Rating
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}
