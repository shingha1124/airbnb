//
//  CalenderViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import RxSwift
import UIKit

final class GuestViewController: UIViewController {
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let guestCountViews: [GuestSettingView] = GuestType.allCases.reduce(into: []) { array, _ in
        array.append(GuestSettingView())
    }
    
    private let adultCountView = GuestSettingView()
    private let childrenCountView = GuestSettingView()
    private let babyCountView = GuestSettingView()
    
    private let viewModel: GuestViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: GuestViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info("deinit GuestViewController")
    }
    
    private func bind() {
        
        rx.viewDidLoad
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state().updatedTitle
            .withUnretained(self)
            .bind(onNext: { vc, type in
                vc.updateTitle(type)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().updatedDescription
            .withUnretained(self)
            .bind(onNext: { vc, value in
                vc.updateDescription(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().updatedCount
            .withUnretained(self)
            .bind(onNext: { vc, value in
                vc.updateCount(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().updatedButtonState
            .withUnretained(self)
            .bind(onNext: { vc, value in
                vc.updateButtonEnabled(value)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                guestCountViews.enumerated().map { index, view in view.changeValue.map { (index, $0) } }
            )
            .compactMap { index, value -> GuestChangeCount? in
                guard let type = GuestType(rawValue: index) else {
                    return nil
                }
                return (type, value)
            }
            .bind(to: viewModel.action().changeGuestCount)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(contentStackView)
        
        guestCountViews.forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func updateTitle(_ type: GuestType) {
        guestCountViews[type.index].setTitle(type.title)
    }
    
    private func updateDescription(_ type: GuestType) {
        guestCountViews[type.index].setDescription(type.description)
    }
    
    private func updateCount(_ value: GuestCount) {
        guestCountViews[value.type.index].setCount(value.count)
    }
    
    private func updateButtonEnabled(_ value: GuestButtonState) {
        guestCountViews[value.type.index].setButtonEnable(plus: value.plus, minus: value.minus)
    }
}
