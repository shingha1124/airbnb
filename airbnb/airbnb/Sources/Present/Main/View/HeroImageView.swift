//
//  HeroImageView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxSwift
import UIKit

final class HeroImageView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black.withAlphaComponent(0.3)
        return imageView
    }()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(imageView)
        
        snp.makeConstraints {
            $0.bottom.equalTo(imageView)
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    func setImage(url: URL) {
        imageManager.loadImage(url: url).asObservable()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { view, image in
                let size = view.imageView.frame.size
                let aspect = (size.width / image.size.width)
                
                view.imageView.image = image
                view.imageView.snp.updateConstraints {
                    $0.height.equalTo(image.size.height * aspect)
                }
            })
            .disposed(by: disposeBag)
    }
}
