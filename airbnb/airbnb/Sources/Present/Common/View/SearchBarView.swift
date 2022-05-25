//
//  SearchBar.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxRelay
import RxSwift
import UIKit

final class SearchBarView: UIView {
    private let searchBar: UIView = {
        let view = UIView()
        view.backgroundColor = .grey5
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .grey3
        return imageView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString.create("어디로 여행가세요?", options: [.foreground(color: .grey3)])
        return textField
    }()
    
    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4
        return view
    }()
    
    private let overlapButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    let tapped = PublishSubject<Void>()
    let text = PublishSubject<String?>()
    let clear = PublishRelay<Void>()
        
    init(isUseTapped: Bool = false) {
        super.init(frame: .zero)
        overlapButton.isHidden = !isUseTapped
        bind()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        overlapButton.rx.tap
            .bind(to: tapped)
            .disposed(by: disposeBag)
        
        textField.rx.text
            .bind(to: text)
            .disposed(by: disposeBag)
        
        clear
            .withUnretained(self)
            .do { view, _ in
                view.textField.text = ""
            }
            .map { _ in "" }
            .bind(to: text)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        addSubview(searchBar)
        addSubview(overlapButton)
        searchBar.addSubview(icon)
        searchBar.addSubview(icon)
        searchBar.addSubview(textField)
        
        addSubview(bottomBar)
        
        snp.makeConstraints {
            $0.bottom.equalTo(searchBar).offset(16)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(textField).offset(7)
        }
        
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.leading.equalTo(icon.snp.trailing).offset(6.3)
            $0.trailing.equalToSuperview().offset(10)
        }
        
        bottomBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        overlapButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
