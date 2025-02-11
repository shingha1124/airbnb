//
//  LoadgingCollectiionViewController.swift
//  airbnb
//
//  Created by 김동준 on 2022/06/07.
//

import MapKit
import RxRelay
import RxSwift
import UIKit

final class LodgingCollectionViewController: BaseViewController, View {
    static let id = "LoadgingCollectionViewController"
    
    enum Contants {
        static let spacing = 16.0
        static let cellSize = CGSize(width: UIScreen.main.bounds.width - 60, height: 120)
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Contants.cellSize
        layout.minimumLineSpacing = Contants.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 50)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MapCollectionCell.self, forCellWithReuseIdentifier: MapCollectionCell.identifier)
        return collectionView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LodgingCollectionViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state.updateLodging
            .bind(to: collectionView.rx.items(cellIdentifier: MapCollectionCell.identifier, cellType: MapCollectionCell.self)) { _, model, cell in
                cell.bind(viewModel: model)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.willEndDragging
            .bind(onNext: customPaging)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.action.selectedCell)
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
    }
    
    private func customPaging(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = Contants.cellSize.width + Contants.spacing
        let offset = targetContentOffset.pointee
        let index = (offset.x + collectionView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        if collectionView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        let offsetX = roundedIndex * cellWidthIncludingSpacing - collectionView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: offsetX, y: 0)
        collectionView.layoutIfNeeded()
    }
}
