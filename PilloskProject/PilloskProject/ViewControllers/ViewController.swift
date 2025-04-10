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

        loadData()
        configureUI()
        setupCollectionView()
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

                    let categoryNames = productData.categories.map { $0 }
                    self.categoryView.notifyCategoryButtonsUpdate(categories: categoryNames)
                    // 앱실행시 첫번째 선택 결과를 받겠다고 클로저 호출 및 동작
                    self.setCollectionViewProducts()
                    // 강제로 버튼을 눌러서 menulist 보여줌
                    if let firstCategorySet = categoryNames.first {
                        self.categoryView.selectedFirstCategory(name: firstCategorySet.name)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    // CategoryView 클로저 함수
    private func setCollectionViewProducts() {
        categoryView.categorySelected = { [weak self] products in
            guard let self = self else { return }
            self.products = products
            self.menuListView.pageControl.numberOfPages = Int(
                ceil(Double(products.count) / Double(self.itemsPerPage))
            )
            self.menuListView.collectionView.reloadData()
        }
    }
    // 메인 view 오토레이아웃 함수
    func configureUI() {
        view.addSubview(categoryView)
        categoryView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }

        view.addSubview(menuListView)

        menuListView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400)
        }

        view.addSubview(orderSummaryView)
        orderSummaryView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }

    }
    /// 컬렉션 뷰의 데이터 소스 연결 및 셀 등록
    private func setupCollectionView() {
        menuListView.collectionView.dataSource = self
        // ProductCell 셀 등록 (재사용을 위한 identifier 설정)
        menuListView.collectionView.register(ProductCell.self, forCellWithReuseIdentifier: CellIdentifier.productCell)
    }
}

extension ViewController: UICollectionViewDataSource {
    /// 컬렉션 뷰에 표시할 아이템(셀)의 총 개수 반환
    /// - Parameters:
    ///   - collectionView: 현재 컬렉션 뷰
    ///   - section: 섹션 번호 (현재는 1개)
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
