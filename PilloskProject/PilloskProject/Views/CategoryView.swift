//
//  CategoryView..swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit
import SnapKit

protocol CategoryViewDelegate: AnyObject {
    func setCategoryButtons(categories: [String])
}

class CategoryView: UIView {

    private var buttons: [UIButton] = []

    weak var delegate: CategoryViewDelegate?

    private func setUpCategoryButton(categories: [String]) {
        categoryContentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for items in categories {
            var configuration = UIButton.Configuration.filled()
            configuration.title = items
            configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            configuration.baseBackgroundColor = .systemBlue
            configuration.baseForegroundColor = .white
            configuration.background.strokeColor = .cyan
            configuration.cornerStyle = .capsule
            configuration.buttonSize = .medium
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let button = UIButton(configuration: configuration, primaryAction: nil)
            button.configurationUpdateHandler = { button in
                if button.isSelected {
                    button.configuration?.baseBackgroundColor = .darkGray
                } else {
                    button.configuration?.baseBackgroundColor = .systemBlue
                }
            }
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            categoryContentsStackView.addArrangedSubview(button)
        }

    }

    func notifyCategoryButtonsUpdate(categories: [String]) {
        setUpCategoryButton(categories: categories)
    }

    @objc private func buttonTapped(_ sender: UIButton) {

        sender.isSelected.toggle()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()

    }

    let categoryViewTitleLabel = UILabel()
    let categoryItems: [Category] = []
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

        categoryScrollView.backgroundColor = .red
        categoryContentsStackView.backgroundColor = .blue

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
        }

        categoryContentsStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(categoryScrollView.contentLayoutGuide)
            $0.height.equalTo(categoryScrollView.frameLayoutGuide)
            $0.leading.equalTo(categoryScrollView.snp.leading).inset(20)
            $0.trailing.equalTo(categoryScrollView.snp.trailing).offset(-20)
        }
    }

}
