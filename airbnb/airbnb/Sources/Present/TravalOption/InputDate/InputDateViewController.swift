//
//  InputDateViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import RxRelay
import RxSwift
import UIKit

final class InputDateViewController: BaseViewController, View {
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
        let viewController = CheckInOutViewController()
        viewController.viewModel = viewModel?.checkInOutViewModel
        viewController.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        return viewController
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString.create("건너뛰기", options: [.underLined]), for: .normal)
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString.create("지우기", options: [.underLined]), for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: InputDateViewModel) {
        viewModel.state.updateCheckInOut
            .map { checkIn, checkOut -> String in
                let checkInText = checkIn?.string("M월 d일 - ") ?? ""
                let checkOutText = checkOut?.string("M월 d일") ?? ""
                return "\(checkInText)\(checkOutText)"
            }
            .bind(to: smallView.rx.value)
            .disposed(by: disposeBag)
        
        viewModel.state.isHiddenSkipButton
            .bind(to: skipButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state.isHiddenRemoveButton
            .bind(to: removeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        skipButton.rx.tap
            .bind(to: viewModel.action.tappedSkipButton)
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .bind(to: viewModel.action.tappedRemoveButton)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: viewModel.action.tappedNextButton)
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        addChild(checkInOutViewController)
        checkInOutViewController.didMove(toParent: self)

        view.addSubview(contentView)

        contentView.addSubview(smallView)
        contentView.addSubview(largeView)

        largeView.addSubview(titleLabel)
        largeView.addSubview(checkInOutViewController.view)
        largeView.addSubview(bottomView)
        
        bottomView.addSubview(skipButton)
        bottomView.addSubview(removeButton)
        bottomView.addSubview(nextButton)
        
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        skipButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }

        checkInOutViewController.view.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1000)
        }
    }
}

extension InputDateViewController: ViewAnimation {

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
