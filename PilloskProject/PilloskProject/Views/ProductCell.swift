//
//  ProductCell.swift
//  PilloskProject
//
//  Created by shinyoungkim on 4/8/25.
//

import UIKit
import SnapKit

final class ProductCell: UICollectionViewCell {    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private var product: Product?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.image = UIImage(named: "CoughMedicine.jpg")
        nameLabel.text = "써콜드플러스"
        priceLabel.text = "\(5800)"
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addButton)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
    }
    
    func configure(with product: Product) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "\(product.price)원"
        imageView.image = UIImage(named: product.image)
    }
}
