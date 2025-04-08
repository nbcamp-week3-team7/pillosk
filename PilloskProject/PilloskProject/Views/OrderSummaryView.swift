//
//  OrderSummaryView.swift
//  PilloskProject
//
//  25.04.08.(화) 오토레이아웃 작업

import UIKit
import SnapKit

class OrderSummaryView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let orderTableView = UITableView()
    let summayCountLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        orderTableView.backgroundColor = .yellow
        
        setTableView()
        summaryCountLabel()
    }
    
    // ===== 테이블뷰 세팅 =====
    func setTableView() {
        orderTableView.frame = view.bounds
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        [orderTableView, summayCountLabel].forEach { view.addSubview($0) }
        
        orderTableView.register(StackTableViewCell.self, forCellReuseIdentifier: "stackCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackCell", for: indexPath) as! StackTableViewCell
        
        // 두 개의 레이블에만 텍스트 설정
        cell.nameLabel.text = "Row \(indexPath.row) - NameLabel"
        cell.priceLabel.text = "Row \(indexPath.row) - PriceLabel"
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func summaryCountLabel() {
        summayCountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        summayCountLabel.text = ("총 3개 입니다.")
        summayCountLabel.textAlignment = .left
        
        summayCountLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(70)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
    }
}

// ===== 스택뷰 테이블셀 커스텀 정의 =====
class StackTableViewCell: UITableViewCell {
    let stackView = UIStackView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .blue
        
        [nameLabel, priceLabel].forEach() { stackView.addArrangedSubview($0) }
        contentView.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder): has not been implemented")
    }
}
