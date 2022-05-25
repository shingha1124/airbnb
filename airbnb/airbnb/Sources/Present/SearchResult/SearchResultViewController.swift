//
//  SearchResultView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import RxRelay
import RxSwift
import UIKit

final class SearchResultViewController: UIViewController {
    enum Contants {
        static let collectionViewInset = 16.0
        static let cellSize = CGSize(width: UIScreen.main.bounds.width - collectionViewInset * 2, height: 64)
    }
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = Contants.cellSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SearchResultCellView.self, forCellWithReuseIdentifier: SearchResultCellView.identifier)
        return collectionView
    }()
    
    private let viewModel: SearchResultViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: SearchResultViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.state().updatedSearchResult
            .bind(to: collectionView.rx.items(cellIdentifier: SearchResultCellView.identifier, cellType: SearchResultCellView.self)) { _, model, cell in
                cell.setViewModel(model)
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Contants.collectionViewInset)
        }
    }
}
