//
//  MainSearchView.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/02.
//

import UIKit

final class MainSearchView: UIView {
    
    private enum Contants {
        static let contentViewHeight = 60.0
    }
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Contants.contentViewHeight / 2
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "magnifyingglass")
        imageView.image = image
        imageView.tintColor = .black
        return imageView
    }()
    
    private let travalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "어디로 여행가세요?"
        return label
    }()
    
    private let travalOptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.text = "어디든지 언제든 게스트"
        label.textColor = .grey1
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    private func bind() {
        backgroundColor = .grey6
    }
    
    private func attribute() {
    }
    
    private func layout() {
        addSubview(contentView)
        
        contentView.addSubview(searchIcon)
        contentView.addSubview(travalLabel)
        contentView.addSubview(travalOptionLabel)
        
        snp.makeConstraints {
            $0.bottom.equalTo(contentView).offset(16)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(Contants.contentViewHeight)
        }
        
        searchIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(23)
        }
        
        travalLabel.snp.makeConstraints {
            $0.leading.equalTo(searchIcon.snp.trailing).offset(16)
            $0.bottom.equalTo(contentView.snp.centerY).inset(3)
        }
        
        travalOptionLabel.snp.makeConstraints {
            $0.leading.equalTo(searchIcon.snp.trailing).offset(16)
            $0.top.equalTo(contentView.snp.centerY).offset(3)
        }
    }
}
