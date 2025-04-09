//
//  UIView+Extensions.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//
import UIKit

extension UIColor {

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension ViewController: CategoryViewDelegate {
    func setCategoryButtons(categories: [String]) {
        categoryView.notifyCategoryButtonsUpdate(categories: categories)
    }
}

protocol ProductCellDelegate: AnyObject {
    func didTapAddButton(product: Product)
}

protocol OrderSummaryViewDelegate: AnyObject {
    func didAddProduct(_ product: Product)
}

