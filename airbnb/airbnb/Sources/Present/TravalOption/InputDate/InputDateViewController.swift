//
//  InputDateViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import RxRelay
import RxSwift
import UIKit

final class InputDateViewController: UIViewController {
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let smallView: TravalOptionMenuItemView = {
        let menuItemView = TravalOptionMenuItemView()
        menuItemView.title = "날짜"
        return menuItemView
    }()
    
    private let largeView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 시기를 알려주세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var checkInOutViewController: CheckInOutViewController = {
        let checkInOutVC = CheckInOutViewController(viewModel: viewModel.checkInOutViewModel)
        checkInOutVC.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
        return checkInOutVC
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let viewModel: InputDateViewModelProtocol
    private let disposeBag = DisposeBag()
        
    init(viewModel: InputDateViewModelProtocol) {
        self.viewModel = viewModel
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
        Log.info("deinit InputDateViewController")
    }
    
    private func bind() {
    }
    
    private func attribute() {
    }
    
    private func layout() {
        addChild(checkInOutViewController)

        view.addSubview(contentView)

        contentView.addSubview(smallView)
        contentView.addSubview(largeView)

        largeView.addSubview(titleLabel)
        largeView.addSubview(checkInOutViewController.view)
        largeView.addSubview(bottomView)
        
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
            $0.height.equalTo(70)
        }

        largeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        bottomView.backgroundColor = .blue
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }

        checkInOutViewController.view.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    func show(safeAreaGuide: UILayoutGuide) {
    }
    
    func hidden() {
    }
}

extension InputDateViewController: TravalOptionAnimation {

    func startShowAnimation(safeAreaGuide: UILayoutGuide) {
        smallView.alpha = 0
        largeView.alpha = 1
        
        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(safeAreaGuide)
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
