import UIKit
import SnapKit

/// 테이블뷰 셀 커스텀 클래스
/// 스택뷰 및 다양한 UI 요소를 포함
class StackTableViewCell: UITableViewCell {
    weak var delegate: StackTableViewCellDelegate?

    let countContainerView = UIView()
    let verticalStackView = UIStackView()
    let horizontalStackView = UIStackView()

    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let minusButton = UIButton()
    let plusButton = UIButton()
    let countLabel = UILabel()
    let deleteButton = UIButton()

    private var unitPrice: Int = 0

    /// 이름 레이블 설정
    private func nameLabelSettings() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.textColor = .black
    }

    /// 가격 레이블 설정
    private func priceLabelSettings() {
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        priceLabel.textColor = .black
    }

    /// 마이너스 버튼 설정
    private func minusButtonSettings() {
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        minusButton.setTitleColor(.white, for: .normal)
        minusButton.backgroundColor = .clear
    }

    /// 플러스 버튼 설정
    private func plusButtonSettings() {
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        plusButton.setTitleColor(.white, for: .normal)
        plusButton.backgroundColor = .clear
    }

    /// 카운트 레이블 설정
    private func countLabelSettings() {
        countLabel.text = "1"
        countLabel.font = UIFont.systemFont(ofSize: 15)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .clear
        countLabel.textColor = .white
    }

    /// 카운트 컨테이너 설정
    private func countContainerViewSettings() {
        countContainerView.backgroundColor = .systemBlue
        countContainerView.layer.cornerRadius = 15
        countContainerView.clipsToBounds = true

        [minusButton, countLabel, plusButton].forEach { countContainerView.addSubview($0) }
    }

    /// 삭제 버튼 설정
    private func deleteButtonSettings() {
        deleteButton.setTitle("X", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.layer.cornerRadius = 15
    }

    /// 스택뷰 설정
    private func setupStackView() {
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill

        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .fillEqually
    }

    /// 스택뷰 레이아웃 설정
    private func setLayoutStackView() {
        countContainerView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(90)
        }

        minusButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }

        plusButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(30)
            make.leading.equalTo(countLabel.snp.trailing)
        }

        countLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.leading.equalTo(minusButton.snp.trailing)
            make.trailing.equalTo(plusButton.snp.leading)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().offset(-10)
        }
    }

    /// 셀 구성 메서드
    /// - name: 상품 이름
    /// - price: 상품 개별 가격
    /// - quantity: 상품 수량
    func configure(name: String, price: Int, quantity: Int) {
        nameLabel.text = name
        unitPrice = price                       // 개별 가격
        updatePriceLabel(quantity: quantity)    // 초기 가격
        countLabel.text = "\(quantity)"
    }

    /// 가격 레이블 업데이트
    /// - quantity: 상품 수량
    private func updatePriceLabel(quantity: Int) {
        let totalPrice = unitPrice * quantity
        priceLabel.text = "\(totalPrice.formattedWithComma())원"
    }

    /// 셀 초기화 메서드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabelSettings()
        priceLabelSettings()
        minusButtonSettings()
        plusButtonSettings()
        countLabelSettings()
        deleteButtonSettings()
        countContainerViewSettings()
        setupStackView()

        [nameLabel, priceLabel].forEach { verticalStackView.addArrangedSubview($0) }
        [verticalStackView, countContainerView, deleteButton].forEach { horizontalStackView.addArrangedSubview($0) }

        contentView.addSubview(horizontalStackView)
        setLayoutStackView()

        /// 버튼에 액션 추가
        deleteButton.addTarget(self,
                               action: #selector(deleteButtonTapped),
                               for: .touchUpInside)
        minusButton.addTarget(self,
                              action: #selector(minusButtonTapped),
                              for: .touchUpInside)
        plusButton.addTarget(self,
                             action: #selector(plusButtonTapped),
                             for: .touchUpInside)
    }

    /// 삭제 버튼 클릭 이벤트
    /// 셀 삭제 요청을 delegate에 전달
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(cell: self)
    }

    /// 마이너스 버튼 클릭 이벤트
    /// 상품 수량 감소 및 UI 업데이트
    @objc private func minusButtonTapped() {
        guard let currentCount = Int(countLabel.text ?? "0"), currentCount > 1 else {
            print("1개 이하 구매 불가")
            return
        }
        let updatedCount = currentCount - 1
        countLabel.text = "\(updatedCount)"
        updatePriceLabel(quantity: updatedCount)
        delegate?.didUpdateQuantity(cell: self, quantity: updatedCount)
    }

    /// 플러스 버튼 클릭 이벤트
    /// 상품 수량 증가 및 UI 업데이트
    @objc private func plusButtonTapped() {
        guard let currentCount = Int(countLabel.text ?? "0") else { return }

        let updateCount = currentCount + 1
        countLabel.text = "\(updateCount)"
        updatePriceLabel(quantity: updateCount)
        delegate?.didUpdateQuantity(cell: self, quantity: updateCount)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// countLabel 값 업데이트 함수
    /// - increment: true면 수량 증가, false면 감소
    func updateCountLabel(increment: Bool) {
        guard let currentCount = Int(countLabel.text ?? "0") else { return }

        let updatedCount = increment ? currentCount + 1 : currentCount - 1

        if updatedCount < 0 {
            print("0 이하 조작 불가")
            return
        } else if updatedCount > 100 {
            print("100 이상 조작 불가")
            return
        }
        countLabel.text = "\(updatedCount)"
    }
}
