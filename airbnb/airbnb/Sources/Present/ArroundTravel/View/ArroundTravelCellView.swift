//
//  HomeTravelViewCell.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxSwift
import UIKit

final class ArroundTravelCellView: UICollectionViewCell {
    static var identifier: String { .init(describing: self) }
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let travalName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .grey1
        return label
    }()
    
    let distance: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .grey3
        return label
    }()
    
    private let cellButton = UIButton()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(_ viewModel: ArroundTravelCellViewModelProtocol) {
        viewModel.state().updateName
            .bind(to: travalName.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state().updatedistance
            .bind(to: distance.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state().updateThumbnail
            .withUnretained(self)
            .flatMapLatest { view, url in
                view.imageManager.loadImage(url: url).asObservable()
            }
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, image in
                cell.icon.image = image
            })
            .disposed(by: disposeBag)
        
        cellButton.rx.tap
            .bind(to: viewModel.action().tappedCell)
            .disposed(by: disposeBag)
        
        viewModel.action().viewLoad.accept(())
    }
    
    private func layout() {
        addSubview(icon)
        addSubview(travalName)
        addSubview(distance)
        addSubview(cellButton)
        
        icon.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(icon.snp.height)
        }
        
        travalName.snp.makeConstraints {
            $0.bottom.equalTo(snp.centerY).inset(2)
            $0.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        distance.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(2)
            $0.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
