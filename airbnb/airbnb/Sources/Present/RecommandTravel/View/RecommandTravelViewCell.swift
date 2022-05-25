//
//  HomeTravelViewCell.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxSwift
import UIKit

final class RecommandTravelViewCell: UICollectionViewCell {
    static var identifier: String { .init(describing: self) }
    
    let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .grey1
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private let disposeBag = DisposeBag()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(thumbnail)
        addSubview(title)
        
        thumbnail.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(308)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(thumbnail.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setTraval(_ traval: RecommandTraval) {
        imageManager.loadImage(url: traval.imageUrl).asObservable()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, image in
                cell.thumbnail.image = image
            })
            .disposed(by: disposeBag)
        
        title.text = traval.title
    }
}
