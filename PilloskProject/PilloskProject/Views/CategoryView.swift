//
//  CategoryView..swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//
import UIKit
import SnapKit

protocol CategoryViewDelegate: AnyObject {
    
}

class CategoryView: UIView {
    
    private let dataService = DataService()
    private var productData: [ProductData] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func loadData() {
        dataService.loadData { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let productData):
                    self.productData = productData
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    let categoryViewTitleLabel = UILabel()
    let categoryStackView = 
    let categoryScrollView = UIScrollView()
    
    
    
    
    private func configureUI() {
        //issue: json data로 만드는게 깔끔하지 않을까 고민됩니다.
        categoryViewTitleLabel.text = "pillosk"
        categoryViewTitleLabel.font = .boldSystemFont(ofSize: 30)
        
        categoryScrollView
        
        
        [categoryViewTitleLabel, categoryScrollView]
            .forEach{addSubview($0)}
    }
    
}
