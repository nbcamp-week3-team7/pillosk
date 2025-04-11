//
//  UIView+Extensions.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//
import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

/// OrderSummaryView에서 사용
/// 부모 뷰 컨트롤러를 가져오는 확장 메서드
extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let response = responder {
            if let viewController = response as? UIViewController {
                return viewController
            }
            responder = response.next
        }
        return nil
    }
}

/// /// OrderSummaryView에서 사용 (UIView 확장)
/// 특정 방향으로 코너를 둥글게 만드는 메서드 제공
extension UIView {
    func applyRoundedCorners(corners: UIRectCorner, radius: CGSize) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

/// OrderSummaryView에서 사용
/// 숫자를 천 단위로 콤마(,) 추가하여 문자열로 반환
extension Int {
    func formattedWithComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
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
