//
//  HomeTravelView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxRelay
import RxSwift
import UIKit

final class ArroundTravalMiniViewController: BaseViewController, View {
    enum Constants {
        static let cellSize = CGSize(width: 253, height: 74)
        static let minimumLineSpacing = 24.0
    }
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = Constants.cellSize
        flowLayout.minimumLineSpacing = Constants.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ArroundTravelCellView.self, forCellWithReuseIdentifier: ArroundTravelCellView.identifier)
        return collectionView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: ArroundTravalViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.loadArroundTravel)
            .disposed(by: disposeBag)
        
        viewModel.state.loadedAroundTraval
            .bind(to: collectionView.rx.items(cellIdentifier: ArroundTravelCellView.identifier, cellType: ArroundTravelCellView.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(collectionView)
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(collectionView)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo((Constants.cellSize.height * 2) + Constants.minimumLineSpacing)
        }
    }
}
