//
//  OrderSummaryView.swift
//  PilloskProject
//
//  25.04.08.(화) 오토레이아웃 작업

import UIKit
import SnapKit

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
        
        nameLabel.text = "TestNameLabel"
        priceLabel.text = "TestPriceLabel"
        
        [nameLabel, priceLabel].forEach() { stackView.addArrangedSubview($0) }
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.trailing.equalToSuperview().inset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder): has not been implemented")
    }
}

class OrderSummaryView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let orderTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        orderTableView.backgroundColor = .yellow
        
        orderTableView.frame = view.bounds
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        orderTableView.register(StackTableViewCell.self, forCellReuseIdentifier: "stackCell")
        view.addSubview(orderTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackCell", for: indexPath) as! StackTableViewCell
        
        // 두 개의 레이블에만 텍스트 설정
        cell.nameLabel.text = "Row \(indexPath.row) - 첫 번째 텍스트"
        cell.priceLabel.text = "Row \(indexPath.row) - 두 번째 텍스트"
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
