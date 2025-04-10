//
//  CategoryView..swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit
import SnapKit
import Combine

class CategoryView: UIView {
    @Published var selectedProducts: [Product] = []
    private var categories: [Category] = []
    private var buttons: [UIButton] = []

    // 데이터 보내주는 클로저
    var categorySelected: (([Product]) -> Void)?

    // 버튼 셋업 메서드
    private func configureCategoryButtons(categories: [Category]) {
        categoryContentsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for items in categories {
            var configuration = UIButton.Configuration.filled()
            configuration.title = items.name
            configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            configuration.baseForegroundColor = .white
            // configuration.background.strokeColor = .cyan
            configuration.cornerStyle = .capsule
            configuration.buttonSize = .medium
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let button = UIButton(configuration: configuration, primaryAction: nil)
            // 버튼 선택했을시 색상 변경 핸들러
            button.configurationUpdateHandler = { button in
                var config = button.configuration
                switch button.state {
                case .selected:
                    config?.baseBackgroundColor = .darkGray
                default:
                    config?.baseBackgroundColor = UIColor(hex: "1B8DFF")
                }
                button.configuration = config
            }
            button.snp.makeConstraints {
                $0.width.equalTo(100)
            }
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            categoryContentsStackView.addArrangedSubview(button)
        }
    }

    // VC에서 호출되는 메서드
    func notifyCategoryButtonsUpdate(categories: [Category]) {
        self.categories = categories
        configureCategoryButtons(categories: categories)

    }
    // 첫번째
    func selectedFirstCategory(name: String) {
        guard let button = buttons.first(where: { $0.configuration?.title == name }) else { return }
        buttonTapped(button)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        // 버튼 상태 확인
        for button in buttons {
            button.isSelected = (button == sender)
        }
        guard let selectedButton = sender.configuration else {
            print("occured error")
            return
        }
        guard let title = selectedButton.title,
              let selectedCategory = categories.first(where: { $0.name == title }) else {
            return
        }
        categorySelected?(selectedCategory.products)
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
    let categoryItems: [String] = []
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
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview()
        }

    }

}
