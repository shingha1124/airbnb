//
//  PersonSettingView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/26.
//

import RxSwift
import UIKit

final class GuestOptionItemView: UIView {
    
    private let guestLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .grey1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .grey3
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .grey1
        label.textAlignment = .center
        return label
    }()
    
    private let plusButton: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        let image = UIImage(systemName: "plus.circle", withConfiguration: largeConfig)
        let normalImage = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let disabledImage = image?.withTintColor(.grey5, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.setImage(normalImage, for: .normal)
        button.setImage(disabledImage, for: .disabled)
        return button
    }()
    
    private let minusButton: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        let image = UIImage(systemName: "minus.circle", withConfiguration: largeConfig)
        let normalImage = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let disabledImage = image?.withTintColor(.grey5, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.setImage(normalImage, for: .normal)
        button.setImage(disabledImage, for: .disabled)
        return button
    }()
    
    private let viewModel: GuestOptionItemViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: GuestOptionItemViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        layout()
        bind(viewModel: viewModel)
        viewModel.action().loadGuestData.accept(())
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    func bind(viewModel: GuestOptionItemViewModelProtocol) {
        viewModel.state().updateTitle
            .bind(to: guestLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state().updateDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state().updateCount
            .map { String($0) }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state().updateCount
            .map { $0 > 0 }
            .bind(to: minusButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.state().isMax
            .map { !$0 }
            .bind(to: plusButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .map { 1 }
            .bind(to: viewModel.action().tappedChangeCount)
            .disposed(by: disposeBag)

        minusButton.rx.tap
            .map { -1 }
            .bind(to: viewModel.action().tappedChangeCount)
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        addSubview(guestLabel)
        addSubview(descriptionLabel)
        addSubview(countLabel)
        addSubview(plusButton)
        addSubview(minusButton)
        
        snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel).offset(16)
        }
        
        guestLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(guestLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(36)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(plusButton.snp.leading).offset(-8)
            $0.centerY.equalTo(plusButton)
            $0.width.height.equalTo(36)
        }
        
        minusButton.snp.makeConstraints {
            $0.trailing.equalTo(countLabel.snp.leading).offset(-8)
            $0.centerY.equalTo(plusButton)
            $0.width.height.equalTo(36)
        }
    }
}
