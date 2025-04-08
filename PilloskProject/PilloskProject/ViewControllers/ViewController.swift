//
//  ViewController.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let orderSummaryVC = OrderSummaryView()
    
    let categoryView = CategoryView()
    override func viewDidLoad() {
        super.viewDidLoad()
        addOrderSummaryViewController()
    }
    
    func addOrderSummaryViewController() {
        addChild(orderSummaryVC)
        view.addSubview(orderSummaryVC.view)
        orderSummaryVC.view.frame = view.bounds
        orderSummaryVC.didMove(toParent: self)
        
        orderSummaryVC.view.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

