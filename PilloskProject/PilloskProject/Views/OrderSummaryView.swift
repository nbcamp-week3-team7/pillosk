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
    
    private let orderData = OrderSummaryData() //데이터 관리 객체
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
        orderTableView.showsVerticalScrollIndicator = false // 세로 스크롤 숨기기
        
        let subviews = [orderTableView, summaryCountLabel, resetButton, paymentButton, lineView]
        subviews.forEach { addSubview($0) }
        
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
        orderData.addOrderItem(product: product)
        
        /// 테이블뷰 갱신 및 UI 업데이트
        orderTableView.reloadData()
        updateSummaryCountLabel()
        updateButtons(isEnabled: orderData.getOrderItemCount() > 0)
        updatePaymentButtonTitle()
    }
    
    /// 테이블뷰의 섹션별 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderData.getOrderItemCount()
    }
    
    /// 테이블뷰 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    /// 테이블뷰 셀 생성 및 데이터 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackCell", for: indexPath) as! StackTableViewCell
        
        let menuItem = orderData.getOrderItems()[indexPath.row]
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
        
        orderData.removeOrderItem(at: indexPath.row)
        orderTableView.deleteRows(at: [indexPath], with: .automatic)
        updateSummaryCountLabel()
        updateButtons(isEnabled: orderData.getOrderItemCount() > 0)
        updatePaymentButtonTitle()
    }
    
    /// 테이블뷰 셀 수량 변경 요청 처리
    /// - 특정 셀의 수량 변경 후 UI 업데이트
    func didUpdateQuantity(cell: StackTableViewCell, quantity: Int) {
        guard let indexPath = orderTableView.indexPath(for: cell) else { return }
        
        /// orderData를 통해 수량 업데이트
        if quantity <= 0 {
            return //음수 결제 불가
        }
        
        orderData.updateOrderItemQuantity(at: indexPath.row, quantity: quantity)
        orderTableView.reloadRows(at: [indexPath], with: .automatic) // 셀만 갱신
        updatePaymentButtonTitle()
        updateSummaryCountLabel()
    }
    
    /// 총 가격 계산
    /// - 주문 목록의 가격과 수량을 곱하여 총합 계산
    private func calculateTotalPrice() -> Int {
        return orderData.calculateTotalPrice()
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
        let totalQuantity = orderData.getOrderItems().reduce(0) { $0 + $1.quantity }
        summaryCountLabel.text = " 총 \(totalQuantity)개"
    }
    
    /// 버튼 활성화 상태 업데이트
    /// - 주문 항목이 없으면 버튼 비활성화
    func updateButtons(isEnabled: Bool) {
        let buttonColor: UIColor = isEnabled ? .systemBlue : .lightGray
        resetButton.isEnabled = isEnabled
        paymentButton.isEnabled = isEnabled
        paymentButton.backgroundColor = buttonColor
        paymentButton.setTitleColor(.white, for: .normal)
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
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.orderData.clearOrderItems()
            self.orderTableView.reloadData()
            self.updateSummaryCountLabel()
            self.updateButtons(isEnabled: false)
            self.updatePaymentButtonTitle()
            if !isReset {
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
