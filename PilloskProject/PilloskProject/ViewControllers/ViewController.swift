//
//  ViewController.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit

class ViewController: UIViewController {

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
        }
    }
}
