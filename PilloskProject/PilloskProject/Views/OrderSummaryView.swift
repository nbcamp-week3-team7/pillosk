//
//  OrderSummaryView.swift
//  PilloskProject
//
//  이부용 작성
//  25.04.08.(화) 오토레이아웃 작업

import UIKit
import SnapKit

/// 주문 요약 화면 클래스
/// 테이블뷰, 버튼, 레이블 등 UI 요소를 포함하며 오토레이아웃을 설정
class OrderSummaryView: UIView, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: CategoryViewDelegate?
    
    let orderTableView = UITableView()
    let summaryCountLabel = UILabel()
    let resetButton = UIButton()
    let paymentButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    /// UI 초기 설정 및 레이아웃 배치 함수 호출
    private func setupUI() {
        [orderTableView, summaryCountLabel, resetButton, paymentButton].forEach { self.addSubview($0) }
        
        setTableView()
        summaryCountLabelSetting()
        resetOrderButton()
        processPayment()
    }
    
    /// 테이블뷰 초기 설정
    /// 데이터소스, 델리게이트 설정 및 레이아웃 배치
    func setTableView() {
        orderTableView.dataSource = self
        orderTableView.delegate = self
        orderTableView.register(StackTableViewCell.self, forCellReuseIdentifier: "stackCell")
        
        orderTableView.snp.makeConstraints { make in
            make.top.equalTo(summaryCountLabel.snp.bottom).offset(2)
            make.trailing.leading.equalToSuperview().inset(5)
            make.bottom.equalTo(paymentButton)
        }
    }
    
    /// 테이블뷰의 섹션별 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 수정 필요: 메뉴 클릭 수에 따라 변경
    }
    
    /// 테이블뷰 셀 생성 및 데이터 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackCell", for: indexPath) as! StackTableViewCell
        
        cell.nameLabel.text = "Row \(indexPath.row) - NameLabel" // 수정 필요: 데이터 처리
        cell.priceLabel.text = "Row \(indexPath.row) - PriceLabel" // 수정 필요: 데이터 처리
        
        return cell
    }
    
    /// 테이블뷰 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    /// 요약 레이블 초기 설정
    /// 텍스트, 폰트, 배경색 및 레이아웃 배치
    func summaryCountLabelSetting() {
        summaryCountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        summaryCountLabel.text = ("총 n개") // 수정 필요: 데이터 처리
        summaryCountLabel.textAlignment = .left
        
        summaryCountLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    /// 초기화 버튼 설정
    /// 텍스트, 폰트, 배경색 및 코너 라운드 적용
    func resetOrderButton() {
        resetButton.setTitle("처음으로", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.backgroundColor = .white
        resetButton.titleLabel?.textAlignment = .center
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)

        resetButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    /// 결제 버튼 설정
    /// 텍스트, 폰트, 배경색 및 코너 라운드 적용
    func processPayment() {
        paymentButton.setTitle("n원 결제하기", for: .normal) // 수정 필요: 데이터 처리
        paymentButton.setTitleColor(.white, for: .normal)
        paymentButton.backgroundColor = .systemBlue
        paymentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

        paymentButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(resetButton.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
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

/// 테이블뷰 셀 커스텀 클래스
/// 스택뷰 및 다양한 UI 요소를 포함
class StackTableViewCell: UITableViewCell {
    let countContainerView = UIView()
    let verticalStackView = UIStackView()
    let horizontalStackView = UIStackView()
    
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let minusButton = UIButton()
    let plusButton = UIButton()
    let countLabel = UILabel()
    let deleteButton = UIButton()
    
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
        countLabel.text = "1" // 수정 필요: 데이터 처리
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
        
        countLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(minusButton.snp.trailing)
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
            make.top.bottom.trailing.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().offset(-10)
        }
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
        
        [nameLabel, priceLabel].forEach() { verticalStackView.addArrangedSubview($0) }
        [verticalStackView, countContainerView, deleteButton].forEach { horizontalStackView.addArrangedSubview($0) }
        
        contentView.addSubview(horizontalStackView)
        
        setLayoutStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
