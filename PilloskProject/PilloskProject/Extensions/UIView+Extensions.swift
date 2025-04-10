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

/// 상품 셀에서 발생하는 이벤트를 처리하기 위한 델리게이트 프로토콜
/// - 상품 추가 버튼이 눌렸을 때 호출
/// - product: 추가된 상품 정보
protocol ProductCellDelegate: AnyObject {
    func didTapAddButton(product: Product)
}

/// StackTableViewCell에서 발생하는 이벤트를 처리하기 위한 델리게이트 프로토콜
/// - 섹 삭제 처리( cell: 삭제 요청이 발생한 셀)
/// - 셀 수량 업데이트 처리( cell: 수량 변경이 발생한 셀, quantity: 변경된 수량)
protocol StackTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(cell: StackTableViewCell)
    func didUpdateQuantity(cell: StackTableViewCell, quantity: Int)
}
