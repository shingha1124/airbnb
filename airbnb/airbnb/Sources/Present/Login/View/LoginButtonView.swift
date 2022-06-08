//
//  LoginButtonView.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/08.
//

import UIKit

final class LoginButtonView: BaseView {
    
    private let buttonIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    var image: UIImage? {
        didSet {
            buttonIcon.image = image
        }
    }
    
    var buttonColor: UIColor = .grey2 {
        didSet {
            backgroundColor = buttonColor
        }
    }
    
    var text: String? {
        didSet {
            buttonLabel.text = text
        }
    }
    
    override func attribute() {
        layer.cornerRadius = 5
    }
    
    override func layout() {
        addSubview(buttonLabel)
        addSubview(buttonIcon)
        addSubview(loginButton)
        
        buttonIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        buttonLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
