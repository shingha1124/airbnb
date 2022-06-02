//
//  InputSearchViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import RxSwift
import UIKit

final class InputGuestViewController: UIViewController {
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        return view
    }()
    
    let smallView: TravalOptionMenuItemView = {
        let menuItemView = TravalOptionMenuItemView()
        menuItemView.title = "여행자"
        return menuItemView
    }()
    
    private let largeView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alpha = 0
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행자 정보를 알려주세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let guestViewController: GuestViewController
    
    private let viewModel: InputGuestViewModelProtocol
    private let disposeBag = DisposeBag()
        
    init(viewModel: InputGuestViewModelProtocol) {
        self.viewModel = viewModel
        self.guestViewController = GuestViewController(viewModel: viewModel.guestViewModel)
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info("deinit InputGuestViewController")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state().updateGuestCount
            .bind(to: smallView.rx.value)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
    }
    
    private func layout() {
        addChild(guestViewController)
        guestViewController.didMove(toParent: self)
        
        view.addSubview(contentView)
        
        contentView.addSubview(smallView)
        contentView.addSubview(largeView)

        largeView.addArrangedSubview(titleLabel)
        largeView.addArrangedSubview(guestViewController.view)
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(contentView)
        }

        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(smallView)
        }
        
        smallView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }

        largeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(guestViewController.view)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}

extension InputGuestViewController: ViewAnimation {
    func startShowAnimation(safeAreaGuide: UILayoutGuide) {
        smallView.alpha = 0
        largeView.alpha = 1

        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(largeView).offset(16)
        }
    }
    
    func startHiddenAnimation() {
        smallView.alpha = 1
        largeView.alpha = 0

        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(smallView)
        }
    }
}
