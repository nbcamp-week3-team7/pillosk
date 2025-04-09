//
//  CategoryView..swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit
import SnapKit

protocol CategoryViewDelegate: AnyObject {
    func setCategoryButtons(categories: [Stinrg])
}

class CategoryView: UIView {

    private var buttons: [UIButton] = []

    weak var delegate: CategoryViewDelegate?

    private func setUpCategoryButton(categories: [Stinrg]) {
        categoryContentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for items in categories {
            var configuration = UIButton.Configuration.filled()
            configuration.title = items.name
            configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            configuration.baseBackgroundColor = .systemBlue
            configuration.baseForegroundColor = .white
            //configuration.background.strokeColor = .cyan
            configuration.cornerStyle = .capsule
            configuration.buttonSize = .medium
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let button = UIButton(configuration: configuration, primaryAction: nil)
//            button.configurationUpdateHandler = { button in
//                if button.isSelected {
//                    button.configuration?.baseBackgroundColor = .darkGray
//                } else {
//                    button.configuration?.baseBackgroundColor = .systemBlue
//                }
//            }
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            categoryContentsStackView.addArrangedSubview(button)
        }

    }

    func notifyCategoryButtonsUpdate(categories: [Stinrg]) {
        setUpCategoryButton(categories: categories)
    }

    @objc private func buttonTapped(_ sender: UIButton) {

        sender.isSelected.toggle()
//        switch sender.isSelected {
//        case
//        }

    }

//    private func returnProducts(buttonTitle: UIButton) -> [Product] {
//
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()

    }

    let categoryViewTitleLabel = UILabel()
    let categoryItems: [Stinrg] = []
    //    let categoryStackView =
    let categoryScrollView = UIScrollView()
    let categoryContentsStackView = UIStackView()


    private func configureUI() {

        categoryViewTitleLabel.text = "pillosk"
        categoryViewTitleLabel.textAlignment = .center
        categoryViewTitleLabel.font = .boldSystemFont(ofSize: 32)
        categoryViewTitleLabel.numberOfLines = 0
        categoryViewTitleLabel.textColor = UIColor(hex: "1B8DFF")

        categoryScrollView.showsHorizontalScrollIndicator = false

//        categoryScrollView.backgroundColor = .red
//        categoryContentsStackView.backgroundColor = .blue

        categoryContentsStackView.axis = .horizontal
        categoryContentsStackView.spacing = 10
        categoryContentsStackView.alignment = .center

        [categoryViewTitleLabel, categoryScrollView]
            .forEach {addSubview($0)}

        [categoryContentsStackView]
            .forEach {categoryScrollView.addSubview($0)}

        categoryViewTitleLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(categoryViewTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }

        categoryContentsStackView.snp.makeConstraints {
//            $0.top.bottom.equalTo(categoryScrollView)
//            $0.height.equalTo(categoryScrollView)
//            $0.leading.equalTo(categoryScrollView.snp.leading)
//            $0.trailing.equalTo(categoryScrollView.snp.trailing)
            $0.leading.trailing.equalToSuperview()
                $0.height.equalToSuperview()
        }
    }

}
