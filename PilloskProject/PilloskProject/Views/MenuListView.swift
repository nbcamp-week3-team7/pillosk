//
//  MenuListView.swift
//  PilloskProject
//
//  Created by 윤주형 on 4/7/25.
//

import UIKit
import SnapKit

final class MenuListView: UIView {
    /// 상품 리스트를 표시할 컬렉션 뷰
    let collectionView: UICollectionView

    /// 페이지 컨트롤
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 1
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .systemBlue
        return pageControl
    }()

    /// MenuListView 가 코드로 생성될 때 호출
    override init(frame: CGRect) {
        // 컬렉션 뷰 레이아웃 설정
        let layout = UICollectionViewCompositionalLayout { [weak pageControl = pageControl] _, environment in
            // 아이템 (셀) 사이즈 지정
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.45), // 그룹 너비의 45% 차지
                heightDimension: .fractionalHeight(1.0) // 그룹 높이의 100% 차지
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // 수평 그룹: 셀 2개를 가로로 배치
            let horizontalGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), // 컬렉션 뷰 width 에 맞춤
                heightDimension: .fractionalHeight(0.5) // 섹션 높이의 50% 차지
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: horizontalGroupSize,
                subitems: [item, item]
            )

            horizontalGroup.interItemSpacing = .fixed(16)

            horizontalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            // 수직 그룹: 수평 그룹 2개를 세로로 배치
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupSize,
                subitems: [horizontalGroup, horizontalGroup]
            )

            verticalGroup.interItemSpacing = .fixed(16)

            // 섹션 생성
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .paging

            // 스크롤 이동 시 현재 페이지 업데이트
            section.visibleItemsInvalidationHandler = { _, offset, environment in
                let page = round(offset.x / environment.container.contentSize.width)
                DispatchQueue.main.async {
                    pageControl?.currentPage = Int(page)
                }
            }

            return section
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// MenuListView 내의 서브뷰 배치 및 제약 설정
    private func setupViews() {
        addSubview(collectionView)
        addSubview(pageControl)

        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.8)
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
