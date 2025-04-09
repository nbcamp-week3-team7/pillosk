//
//  ViewController.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit
import SnapKit

extension ViewController: ProductCellDelegate {
    func didTapAddButton(product: Product) {
        orderSummaryView.addOrderItem(product: product)
    }
}

final class ViewController: UIViewController {
    let orderSummaryView = OrderSummaryView()
    let categoryView = CategoryView()
    private let dataService = DataService()
    private var productData: [ProductData] = []
    
    /// 상품 리스트 뷰 (UICollectionView + PageControl 포함)
    private let menuListView = MenuListView()
    
    /// 상품 데이터 배열 (현재는 더미 데이터)
    private var products: [Product] = []
    /// 한 페이지에 표시할 상품 수 (2x2 = 4개)
    private let itemsPerPage = 4
    /// 전체 상품을 기반으로 계산한 페이지 수
    private var numberOfPages: Int {
        return Int(ceil(Double(products.count) / Double(itemsPerPage)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(categoryView)
        categoryView.delegate = self
        loadData()
        configureUI()
        setupViews()
        setupCollectionView()
        loadDummyData()
    }

    private func setCollectionView() {
        menuListView.collectionView.dataSource = self
        menuListView.collectionView.register(ProductCell.self, forCellWithReuseIdentifier: CellIdentifier.productCell)
    }
    func loadData() {
        dataService.loadData { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let productData):
                    self.productData = [productData]
                    
                    // 임시로 첫 번째 카테고리 상품을 사용
                    if let firstCategory = productData.categories.first {
                        self.products = firstCategory.products
                        
                        // 페이지 컨트롤 업데이트
                        self.menuListView.pageControl.numberOfPages = Int(ceil(Double(self.products.count) / Double(self.itemsPerPage)))
                        
                        // 컬렉션 뷰 리로드
                        self.menuListView.collectionView.reloadData()
                    }                    
                    
                    let categoryNames = productData.categories.map { $0.name }
                    self.categoryView.notifyCategoryButtonsUpdate(categories: categoryNames)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func configureUI() {
        view.addSubview(categoryView)
        categoryView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        view.addSubview(orderSummaryView)
        orderSummaryView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }

    }
    
    /// 메인 뷰에 menuListView 추가 및 레이아웃 설정
    private func setupViews() {
        view.addSubview(menuListView)
        
        menuListView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400)
        }
    }
    
    /// 컬렉션 뷰의 데이터 소스 연결 및 셀 등록
    private func setupCollectionView() {
        menuListView.collectionView.dataSource = self
        // ProductCell 셀 등록 (재사용을 위한 identifier 설정)
        menuListView.collectionView.register(ProductCell.self, forCellWithReuseIdentifier: CellIdentifier.productCell)
    }
    
    /// 상품 목록 더미 데이터 로드
    private func loadDummyData() {
        // 임시데이터, 추후 수정
        products = [
            Product(name: "비타민C 1000mg", price: 3900, image: "CoughMedicine.jpg"),
            Product(name: "종합감기약", price: 7500, image: "Antipyretic.jpg"),
            Product(name: "에너지 드링크", price: 2500, image: "NasalSpray.jpg"),
            Product(name: "피로 회복제", price: 4800, image: "Painkiller.jpg"),
            Product(name: "소화제", price: 3300, image: "VitaminC.jpg"),
            Product(name: "유산균", price: 8500, image: "Acetaminophen.jpg")
        ]
        
        // 페이지 컨트롤의 전체 페이지 수 업데이트
        menuListView.pageControl.numberOfPages = numberOfPages
        // 컬렉션 뷰 데이터 리로드 (화면 갱신)
        menuListView.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    /// 컬렉션 뷰에 표시할 아이템(셀)의 총 개수 반환
    /// - Parameter collectionView: 현재 컬렉션 뷰
    /// - Parameter section: 섹션 번호 (현재는 1개)
    /// - Returns: 상품 데이터의 총 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    /// 각 셀을 구성하는 메서드
    /// 셀이 화면에 표시될 때마다 호출
    /// - Parameters:
    ///   - collectionView: 현재 컬렉션 뷰
    ///   - indexPath: 셀의 위치 정보
    /// - Returns: 구성된 UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 셀 재사용 큐에서 ProductCell dequeue
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.productCell, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        // indexPath 에 해당하는 상품 데이터 가져오기
        let product = products[indexPath.item]
        cell.delegate = self
        // 셀 구성 (상품명, 가격, 이미지)
        cell.configure(with: product)
        
        return cell
    }
}
