//
//  ProductCell.swift
//  PilloskProject
//
//  Created by shinyoungkim on 4/8/25.
//

import UIKit
import SnapKit

/// 상품 정보를 표시하는 컬렉션 뷰 셀
/// - 이미지, 이름, 가격, 플러스(+) 버튼 포함
final class ProductCell: UICollectionViewCell {
    /// BY: 델리게이트 연결
    weak var delegate: ProductCellDelegate?

    /// 상품 이미지 뷰
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    /// 상품명과 가격을 수직으로 나열하는 스택뷰
    private let productInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        return sv
    }()

    /// 상품명
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    /// 상품 가격
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    /// 상품 정보 + 플러스 버튼을 수평으로 나열하는 스택뷰
    private let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return sv
    }()

    /// 상품을 장바구니에 추가하는 플러스 버튼
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
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside) // BY: Delegate Button Action
    }

    /// BY: 버튼 누르면 델리게이트 동작
    @objc private func addButtonTapped() {
            if let product = product {
                delegate?.didTapAddButton(product: product)
            }
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 셀 내부 뷰들을 추가하고 레이아웃 제약을 설정
    private func setupViews() {
        // 뷰 계층 추가
        contentView.addSubview(imageView)
        contentView.addSubview(horizontalStackView)

        // horizontalStackView 에 상품 정보 스택뷰와 플러스 버튼 추가
        [productInfoStackView, addButton].forEach {
            horizontalStackView.addArrangedSubview($0)
        }

        // 상품 정보 스택뷰에 상품명과 가격 라벨 추가
        [nameLabel, priceLabel].forEach {
            productInfoStackView.addArrangedSubview($0)
        }

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.clipsToBounds = true

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
        }

        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        addButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
    }

    /// 셀에 상품 데이터를 주입하는 메서드
    /// - 호출 시점: 컬렉션 뷰의 cellForItemAt 메서드에서 호출
    /// - Parameter product: 상품 데이터
    func configure(with product: Product) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "\(product.price)원"
        imageView.image = UIImage(named: product.image)
    }
}
