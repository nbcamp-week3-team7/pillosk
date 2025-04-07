//
//  Data.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//
import Foundation

struct ProductData: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let name: String
    let products: [Product]
}

struct Product: Codable {
    let name: String
    let price: Int
    let image: String
}
