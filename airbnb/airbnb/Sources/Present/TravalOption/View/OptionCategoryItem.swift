//
//  OptionCategoryItem.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import UIKit
import RxRelay
import RxSwift

final class OptionCategoryItem: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let button = UIButton()
    
    private let disposeBag = DisposeBag()
    
    let tap = PublishRelay<Void>()
    
    init(type: TravalOptionInfo.OptionType) {
        super.init(frame: .zero)
        nameLabel.text = type.name
        bind()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        button.rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        addSubview(nameLabel)
        addSubview(valueLabel)
        addSubview(button)
        addSubview(topSeparator)
        
        snp.makeConstraints {
            $0.bottom.equalTo(nameLabel).offset(11)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(16)
        }
        
        valueLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topSeparator.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func setvalue(_ value: String) {
        valueLabel.text = value
    }
}
