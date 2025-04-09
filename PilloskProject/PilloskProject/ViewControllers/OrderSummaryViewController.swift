// OrderSummaryViewController.swift
// 이부용 작성
// 25.04.09.구현

import UIKit
import SnapKit

class OrderSummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let orderSummaryView = OrderSummaryView()
    private var orderItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupOrderSummaryView()
        updateUI()
    }
    
    private func setupOrderSummaryView() {
        view.addSubview(orderSummaryView)
        orderSummaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        orderSummaryView.resetButton.addTarget(self,
                                               action: #selector(handleReset),
                                               for: .touchUpInside)
        orderSummaryView.paymentButton.addTarget(self,
                                                 action: #selector(handlePayment),
                                                 for: .touchUpInside)
        
        orderSummaryView.orderTableView.register(StackTableViewCell.self, forCellReuseIdentifier: "stackCell")
        
        orderSummaryView.orderTableView.dataSource = self
        orderSummaryView.orderTableView.delegate = self
    }
    
    @objc private func handleReset() {
        showAlert(title: "확인", message: "정말 모든 항목을 삭제하시겠습니까?") {
            self.orderItems.removeAll()
            self.updateUI()
        }
    }
    
    @objc private func handlePayment() {
        showAlert(title: "확인", message: "결제를 진행하시겠습니까?") {
            print("결제 진행!")
            self.orderItems.removeAll()
            self.updateUI()
        }
    }
    
    private func updateUI() {
        orderSummaryView.updateSummaryCountLabel(count: orderItems.count)
            orderSummaryView.updateButtons(isEnabled: !orderItems.isEmpty)
            orderSummaryView.orderTableView.reloadData()
    }
    
    private func showAlert(title: String, message: String, confirmAction: @escaping () -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in confirmAction() }))
        present(alert, animated: true, completion: nil)
    }
}

extension OrderSummaryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 식별자 수정: "stackCell"로 변경
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackCell", for: indexPath) as! StackTableViewCell
        cell.nameLabel.text = orderItems[indexPath.row]
        cell.deleteButton.addTarget(self,
                                    action: #selector(deleteItem),
                                    for: .touchUpInside)
        return cell
    }
    
    @objc private func deleteItem(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? StackTableViewCell,
              let indexPath = orderSummaryView.orderTableView.indexPath(for: cell) else { return }

        orderItems.remove(at: indexPath.row)
        updateUI()
    }
}

