//
//  SearchAroundView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import RxDataSources
import RxSwift
import UIKit

final class ArroundTravalLargeViewController: UIViewController {
    enum Contants {
        static let collectionViewInset = 16.0
        static let cellSize = CGSize(width: UIScreen.main.bounds.width - collectionViewInset * 2, height: 64)
        static let headerSize = CGSize(width: UIScreen.main.bounds.width - collectionViewInset * 2, height: 64)
    }
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = Contants.cellSize
        flowLayout.headerReferenceSize = Contants.headerSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = true
        collectionView.register(ArroundTravelCellView.self, forCellWithReuseIdentifier: ArroundTravelCellView.identifier)
        collectionView.register(ArroundTravalCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArroundTravalCollectionHeaderView.identifier)
        return collectionView
    }()
    
    private typealias ConfigureCell = (CollectionViewSectionedDataSource<SectionModel<String, ArroundTravelCellViewModel>>, UICollectionView, IndexPath, ArroundTravelCellViewModel) -> UICollectionViewCell
    private typealias ConfigureSupplementaryView = (CollectionViewSectionedDataSource<SectionModel<String, ArroundTravelCellViewModel>>, UICollectionView, String, IndexPath) -> UICollectionReusableView
    
    private let viewModel: ArroundTravalViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: ArroundTravalViewModelProtocol) {
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
        rx.viewDidLoad
            .bind(to: viewModel.action().loadArroundTravel)
            .disposed(by: disposeBag)
        
        let configureCell: ConfigureCell = { _, collectionView, indexPath, model -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArroundTravelCellView.identifier, for: indexPath) as? ArroundTravelCellView else {
                return UICollectionViewCell()
            }
            cell.bind(model)
            return cell
        }
    
        let configureSupplementaryView: ConfigureSupplementaryView = { _, collectionView, kind, indexPath -> UICollectionReusableView in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ArroundTravalCollectionHeaderView.identifier, for: indexPath) as? ArroundTravalCollectionHeaderView else {
                    return UICollectionReusableView()
                }
                header.setTitle("근처의 인기 여행지")
                return header
            }
            return UICollectionReusableView()
        }
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ArroundTravelCellViewModel>>(configureCell: configureCell, configureSupplementaryView: configureSupplementaryView)
        
        viewModel.state().loadedAroundTraval
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Contants.collectionViewInset)
        }
    }
}
