//
//  WishLoginPageView.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/08.
//

import Foundation
import UIKit

final class WishLoginPageView: BaseView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "위시리스트"
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "위시리스트를 확인하려면 로그인하세요"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .baseColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func layout() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(loginButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }
}
