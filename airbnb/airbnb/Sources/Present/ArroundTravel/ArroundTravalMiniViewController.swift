//
//  HomeTravelView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxRelay
import RxSwift
import UIKit

final class ArroundTravalMiniViewController: UIViewController {
    enum Constants {
        static let cellSize = CGSize(width: 253, height: 74)
        static let minimumLineSpacing = 24.0
    }
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가까운 여행지 둘러보기"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .black
        return label
    }()
    
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
        
        viewModel.state().loadedAroundTraval
            .bind(to: collectionView.rx.items(cellIdentifier: ArroundTravelCellView.identifier, cellType: ArroundTravelCellView.self)) { _, model, cell in
                cell.bind(model)
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(contentView)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(collectionView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((Constants.cellSize.height * 2) + Constants.minimumLineSpacing)
        }
    }
}
