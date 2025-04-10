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

/// 메뉴 아이템을 표현하는 데이터 모델
/// - name: 상품 이름
/// - price: 상품 개별 가격
/// - quantity: 상품 수량
struct MenuItem {
    let name: String
    let price: Int
    var quantity: Int
}
