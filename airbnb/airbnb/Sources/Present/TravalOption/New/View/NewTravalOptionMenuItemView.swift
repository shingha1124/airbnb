//
//  NewTravalOptionMenuItem.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import UIKit
import RxSwift
import RxRelay

final class NewTravalOptionMenuItemView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "aaaaa"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let itemButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var value: String = "" {
        didSet {
            valueLabel.text = title
        }
    }
    
    let tap = PublishRelay<Void>()
    
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
        itemButton.rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    private func layout() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(itemButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        itemButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(70)
        }
    }
}
