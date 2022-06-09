//
//  WishButton.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/09.
//

import RxSwift
import UIKit

final class WishButton: BaseView {
    
    private let backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_heartFill")?.withTintColor(.black.withAlphaComponent(0.5))
        return imageView
    }()

    private let foregroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_heart")?.withTintColor(.white)
        return imageView
    }()
    
    private let button = UIButton()
    
    var tap: Observable<Void> {
        button.rx.tap.asObservable()
    }
    
    var isSelected = false {
        didSet {
            let color: UIColor = isSelected ? .baseColor : .black.withAlphaComponent(0.5)
            backgroundView.image = backgroundView.image?.withTintColor(color)
        }
    }
        
    override func attribute() {
    }
    
    override func layout() {
        addSubview(backgroundView)
        addSubview(foregroundView)
        addSubview(button)
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        foregroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
    }
}
