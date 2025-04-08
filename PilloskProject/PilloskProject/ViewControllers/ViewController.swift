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
    private let dataService = DataService()
    private var productData: [ProductData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(categoryView)
        categoryView.delegate = self
        loadData()
        configureUI()

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

    func loadData() {
        dataService.loadData { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let productData):
                    self.productData = [productData]
                    let categoryNames = productData.categories.map { $0.name }
                    self.categoryView.notifyCategoryButtonsUpdate(categories: categoryNames)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func configureUI() {

        categoryView.backgroundColor = .brown

        view.addSubview(categoryView)
        categoryView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(120)
//            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension ViewController: CategoryViewDelegate {
    func setCategoryButtons(categories: [String]) {
        categoryView.notifyCategoryButtonsUpdate(categories: categories)
    }
}
