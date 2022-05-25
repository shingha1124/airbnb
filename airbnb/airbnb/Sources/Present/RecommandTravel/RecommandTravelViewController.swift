//
//  HomeTravelView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxRelay
import RxSwift
import UIKit

final class RecommandTravelViewController: UIViewController {
    enum Constants {
        static let cellSize = CGSize(width: 253, height: 368)
    }
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어디에서나, 여행은\n살아보는거야!"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = Constants.cellSize
        flowLayout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RecommandTravelViewCell.self, forCellWithReuseIdentifier: RecommandTravelViewCell.identifier)
        return collectionView
    }()
    
    private let viewModel: RecommandTravelViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: RecommandTravelViewModelProtocol) {
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
            .bind(to: viewModel.action().loadRecommandTravel)
            .disposed(by: disposeBag)
        
        viewModel.state().loadedRecommandTraval
            .bind(to: collectionView.rx.items(cellIdentifier: RecommandTravelViewCell.identifier, cellType: RecommandTravelViewCell.self)) { _, model, cell in
                cell.setTraval(model)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.cellSize.height)
        }
    }
}
