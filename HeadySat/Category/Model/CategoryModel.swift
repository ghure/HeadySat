//
//  CategoryModel.swift
//  HeadySat
//
//  Created by Captain on 6/28/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import Foundation

struct JsonModel: Codable {
    var categories: [CategoryModel]
    var rankings: [RankingModel]
}

struct CategoryModel: Codable {
    var id: Int
    var name: String
    var products: [ProductModel]
    var child_categories: [Int]
}

struct ProductModel: Codable {
    var id: Int
    var name: String
    var date_added: String
    var variants: [VariantModel]
    var tax: TaxModel
}

struct VariantModel: Codable {
    var id: Int
    var color: String
    var size: Int?
    var price: Int?
}

struct TaxModel: Codable {
    var name: String
    var value: Double
}

struct RankingModel: Codable {
    var ranking: String
    var products: [RankProductModel]
}

struct RankProductModel: Codable {
    var id: Int
    var view_count: Int?
    var order_count: Int?
    var shares: Int?
}
