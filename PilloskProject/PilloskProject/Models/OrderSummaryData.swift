//
// 이부용 작성
// 25.04.10.(목): 주문 목록과 관련된 데이터를 관리하는 로직
// 데이터 추가, 삭제, 수량 업데이트, 총 가격 계산 등의 로직을 처리

import Foundation

/// 주문 요약 데이터를 관리하는 클래스
/// - 주문 목록, 총 가격 계산, 데이터 조작 로직을 포함
class OrderSummaryData {
    private var orderItems: [MenuItem] = []
    
    /// 주문 항목 전체 삭제 (초기화)
    func clearOrderItems() {
        orderItems.removeAll() // 배열 초기화
    }

    /// 주문 항목 추가
    func addOrderItem(product: Product) {
        if let existingIndex = orderItems.firstIndex(where: { $0.name == product.name }) {
            orderItems[existingIndex].quantity += 1
        } else {
            let menuItem = MenuItem(name: product.name, price: product.price, quantity: 1)
            orderItems.append(menuItem)
        }
    }

    /// 주문 항목 삭제
    func removeOrderItem(at index: Int) {
        guard index < orderItems.count else { return }
        orderItems.remove(at: index)
    }

    /// 주문 항목 수량 업데이트
    func updateOrderItemQuantity(at index: Int, quantity: Int) {
        guard index < orderItems.count, quantity > 0 else { return }
        orderItems[index].quantity = quantity
    }

    /// 총 가격 계산
    func calculateTotalPrice() -> Int {
        return orderItems.reduce(0) { $0 + ($1.price * $1.quantity) }
    }

    /// 주문 항목 반환
    func getOrderItems() -> [MenuItem] {
        return orderItems
    }

    /// 주문 항목 개수 반환
    func getOrderItemCount() -> Int {
        return orderItems.count
    }
}
