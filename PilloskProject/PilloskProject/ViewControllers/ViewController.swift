//
//  ViewController.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    let categoryView = CategoryView()
    private let menuListView = MenuListView()
    
    private var products: [Product] = []
    private let itemsPerPage = 4
    private var numberOfPages: Int {
        return Int(ceil(Double(products.count) / Double(itemsPerPage)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupCollectionView()
        loadDummyData()
    }
    
    private func setupViews() {
        view.addSubview(menuListView)
        
        menuListView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
    }
    
    private func setupCollectionView() {
        menuListView.collectionView.dataSource = self
        menuListView.collectionView.delegate = self
        menuListView.collectionView.register(ProductCell.self, forCellWithReuseIdentifier: CellIdentifier.productCell)
    }
    
    private func loadDummyData() {
        /// 임시데이터, 추후 수정
        products = [
            Product(name: "비타민C 1000mg", price: 3900, image: "CoughMedicine.jpg"),
            Product(name: "종합감기약", price: 7500, image: "Antipyretic.jpg"),
            Product(name: "에너지 드링크", price: 2500, image: "NasalSpray.jpg"),
            Product(name: "피로 회복제", price: 4800, image: "Painkiller.jpg"),
            Product(name: "소화제", price: 3300, image: "VitaminC.jpg"),
            Product(name: "유산균", price: 8500, image: "Acetaminophen.jpg")
        ]
        
        menuListView.pageControl.numberOfPages = numberOfPages
        menuListView.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.productCell, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = collectionView.frame.height / 2
        return CGSize(width: width, height: height)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        menuListView.pageControl.currentPage = page
    }
}
