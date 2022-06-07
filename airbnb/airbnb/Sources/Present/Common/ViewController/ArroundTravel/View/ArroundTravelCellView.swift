//
//  HomeTravelViewCell.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxSwift
import UIKit

final class ArroundTravelCellView: BaseCollectionViewCell, View {    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let travalNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .grey1
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .grey3
        return label
    }()
    
    private let cellButton = UIButton()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    
    func bind(to viewModel: ArroundTravelCellViewModel) {
        
        viewModel.state.updateName
            .bind(to: travalNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedistance
            .bind(to: distanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updateThumbnail
            .withUnretained(self)
            .flatMapLatest { view, url in
                view.imageManager.loadImage(url: url).asObservable()
            }
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, image in
                cell.iconImageView.image = image
            })
            .disposed(by: disposeBag)
        
        cellButton.rx.tap
            .bind(to: viewModel.action.tappedCell)
            .disposed(by: disposeBag)
        
        viewModel.action.viewLoad.accept(())
    }
    
    override func layout() {
        addSubview(iconImageView)
        addSubview(travalNameLabel)
        addSubview(distanceLabel)
        addSubview(cellButton)
        
        iconImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(iconImageView.snp.height)
        }
        
        travalNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(snp.centerY).inset(2)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(2)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
        }
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
