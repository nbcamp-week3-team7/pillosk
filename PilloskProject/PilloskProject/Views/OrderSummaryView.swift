//
//  OrderSummaryView.swift
//  PilloskProject
//
//  이부용 작성
//  25.04.08.(화) 오토레이아웃 작업
//  25.04.19.(수) 버튼 로직과 Delegate 연결

import UIKit
import SnapKit

/// 주문 요약 화면 클래스
/// 테이블뷰, 버튼, 레이블 등 UI 요소를 포함하며 오토레이아웃을 설정
final class OrderSummaryView: UIView, UITableViewDataSource, UITableViewDelegate, StackTableViewCellDelegate {

    private var orderItems: [MenuItem] = []

    let orderTableView = UITableView()
    let summaryCountLabel = UILabel()
    let resetButton = UIButton()
    let paymentButton = UIButton()
    let lineView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    /// UI 초기 설정 및 레이아웃 배치 함수 호출
    private func setupUI() {
        [orderTableView, summaryCountLabel, resetButton, paymentButton, lineView].forEach { self.addSubview($0) }

        setLineView()
        setTableView()
        summaryCountLabelSetting()
        resetOrderButton()
        processPayment()
    }

    /// 구분선 설정
    func setLineView() {
        lineView.backgroundColor = .systemGray4
        self.addSubview(lineView)

        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(summaryCountLabel.snp.bottom)
        }
    }

    /// 테이블뷰 초기 설정
    /// 데이터소스와 델리게이트 연결 및 레이아웃 배치
    func setTableView() {
        orderTableView.register(StackTableViewCell.self, forCellReuseIdentifier: "stackCell")

        orderTableView.dataSource = self
        orderTableView.delegate = self

        orderTableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(0)
            make.trailing.leading.equalToSuperview().inset(5)
            make.bottom.equalTo(paymentButton.snp.top)
        }
    }

    /// 결제 버튼 텍스트 업데이트
    /// - 주문 항목의 총 가격을 계산하여 버튼 텍스트를 업데이트
    func updatePaymentButtonTitle() {
        let totalPrice = calculateTotalPrice()
        paymentButton.setTitle("\(totalPrice.formattedWithComma())원 결제하기", for: .normal)
    }

    /// 주문 상품 추가
    /// - 같은 이름의 상품이 있으면 수량만 증가, 없으면 새로 추가
    /// - UI 업데이트: 테이블뷰 갱신, 레이블 및 버튼 상태 변경
    func addOrderItem(product: Product) {
        if let existingIndex = orderItems.firstIndex(where: { $0.name == product.name }) {
            orderItems[existingIndex].quantity += 1
        } else {
            let menuItem = MenuItem(name: product.name, price: product.price, quantity: 1)
            orderItems.append(menuItem)
        }

        /// 테이블뷰 갱신 및 UI 업데이트
        orderTableView.reloadData()
        updateSummaryCountLabel()
        updateButtons(isEnabled: !orderItems.isEmpty)
        updatePaymentButtonTitle()
    }

    /// 테이블뷰의 섹션별 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }

    /// 테이블뷰 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    /// 테이블뷰 셀 생성 및 데이터 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackCell", for: indexPath) as! StackTableViewCell

        let menuItem = orderItems[indexPath.row]
        cell.configure(name: menuItem.name,
                       price: menuItem.price,
                       quantity: menuItem.quantity)
        cell.delegate = self
        return cell
    }

    /// 테이블뷰 셀 삭제 요청 처리
    /// - 특정 셀 삭제 후 UI 업데이트
    func didTapDeleteButton(cell: StackTableViewCell) {
        guard let indexPath = orderTableView.indexPath(for: cell) else { return }

        orderItems.remove(at: indexPath.row)
        orderTableView.deleteRows(at: [indexPath], with: .automatic)
        updateSummaryCountLabel()
        updateButtons(isEnabled: !orderItems.isEmpty)
        updatePaymentButtonTitle()
    }

    /// 테이블뷰 셀 수량 변경 요청 처리
    /// - 특정 셀의 수량 변경 후 UI 업데이트
    func didUpdateQuantity(cell: StackTableViewCell, quantity: Int) {
        guard let indexPath = orderTableView.indexPath(for: cell) else { return }

        if indexPath.row < orderItems.count {
            if quantity <= 0 {
                print("1개 이하 구매 불가")
                return
            }

            orderItems[indexPath.row].quantity = quantity
            updatePaymentButtonTitle()
            updateSummaryCountLabel()
        } else {
            print("IndexPath.row가 배열 범위 초과")
        }
    }

    /// 총 가격 계산
    /// - 주문 목록의 가격과 수량을 곱하여 총합 계산
    private func calculateTotalPrice() -> Int {
        if orderItems.isEmpty {
            return 0
        }
        return orderItems.reduce(0) { $0 + ($1.price * $1.quantity) }
    }

    /// 요약 레이블 초기 설정
    /// 텍스트, 폰트, 배경색 및 레이아웃 배치
    func summaryCountLabelSetting() {
        summaryCountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        updateSummaryCountLabel()
        summaryCountLabel.textAlignment = .left

        summaryCountLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    /// 총 수량 레이블 업데이트
    func updateSummaryCountLabel() {
        let totalQuantity = orderItems.reduce(0) { $0 + $1.quantity }
        summaryCountLabel.text = " 총 \(totalQuantity)개"
    }

    /// 버튼 활성화 상태 업데이트
    /// - 주문 항목이 없으면 버튼 비활성화
    func updateButtons(isEnabled: Bool) {
        let buttonColor: UIColor = isEnabled ? .systemBlue : .lightGray
        let buttonTextColor: UIColor = isEnabled ? .white : .white
        resetButton.isEnabled = isEnabled
        paymentButton.isEnabled = isEnabled
        paymentButton.backgroundColor = buttonColor
        paymentButton.setTitleColor(buttonTextColor, for: .normal)
    }

    /// 초기화 버튼 설정
    /// - 버튼 클릭 시 모든 주문 항목 초기화
    func resetOrderButton() {
        resetButton.setTitle("처음으로", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.backgroundColor = .white
        resetButton.titleLabel?.textAlignment = .center
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        resetButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(150)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        resetButton.addTarget(self,
                              action: #selector(resetButtonTapped),
                              for: .touchUpInside)
    }

    /// 결제 버튼 설정
    /// - 버튼 클릭 시 결제 로직 실행 가능
    func processPayment() {
        paymentButton.setTitle("0원 결제하기", for: .normal)
        paymentButton.setTitleColor(.white, for: .normal)
        paymentButton.backgroundColor = .lightGray
        paymentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

        paymentButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(resetButton.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        paymentButton.addTarget(self,
                                action: #selector(paymentButtonTapped),
                                for: .touchUpInside)
    }

    /// 초기화 버튼 클릭 이벤트
    @objc private func resetButtonTapped() {
        showAlert(title: "확인", message: "전체 목록을 삭제하시겠습니까?", isReset: true)
    }

    /// 결제 버튼 클릭 이벤트
    @objc private func paymentButtonTapped() {
        showAlert(title: "확인", message: "결제를 진행하시겠습니까?", isReset: false)
    }

    /// 알럿 표시 함수
    /// - 초기화 또는 결제 확인을 위한 알럿 표시
    private func showAlert(title: String, message: String, isReset: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.orderItems.removeAll()
            self.orderTableView.reloadData()
            self.updateSummaryCountLabel()
            self.updateButtons(isEnabled: false)
            self.updatePaymentButtonTitle()
            if !isReset {
                print("결제 진행 중")
                /// 추후 추가 결제 로직 기능 작성 가능
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        /// 현재 뷰 컨트롤러에서 알럿 표시
        if let viewController = self.parentViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    /// 코너 라운드 적용
    override func layoutSubviews() {
        super.layoutSubviews()
        resetButton.applyRoundedCorners(corners: [.topLeft, .topRight], radius: CGSize(width: 10, height: 10))
        paymentButton.applyRoundedCorners(corners: [.topLeft, .topRight], radius: CGSize(width: 10, height: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// UIView 확장
/// 특정 방향으로 코너를 둥글게 만드는 메서드 제공
extension UIView {
    func applyRoundedCorners(corners: UIRectCorner, radius: CGSize) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

/// 숫자를 천 단위로 콤마(,) 추가하여 문자열로 반환
extension Int {
    func formattedWithComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

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

/// 부모 뷰 컨트롤러를 가져오는 확장 메서드
extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let response = responder {
            if let viewController = response as? UIViewController {
                return viewController
            }
            responder = response.next
        }
        return nil
    }
}
