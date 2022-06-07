//
//  TravalOptionViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import RxSwift
import UIKit

final class TravalOptionViewController: BaseViewController, View {
    
    enum Constants {
        static let titleViewHeight = 60.0
    }
    
    private let backgroundView: GradientView = {
        let gradientView = GradientView()
        gradientView.set(colors: [.grey4.withAlphaComponent(1), .grey4.withAlphaComponent(0.5)], startPoint: CGPoint(x: 0.5, y: 0.5), endPoint: CGPoint(x: 0.5, y: 1))
        return gradientView
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        return button
    }()
    
    private let closeSearchViewButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        return button
    }()
    
    let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var searchViewController: InputSearchViewController = {
        let searchViewController = InputSearchViewController()
        searchViewController.viewModel = viewModel?.searchViewModel
        searchViewController.view.isHidden = true
        return searchViewController
    }()
    
    lazy var travalViewController: InputTravalViewController = {
        let inputTravalView = InputTravalViewController()
        inputTravalView.viewModel = viewModel?.travalViewModel
        return inputTravalView
    }()
    
    private lazy var dateViewController: InputDateViewController = {
        let inputTravalView = InputDateViewController()
        inputTravalView.viewModel = viewModel?.dateViewModel
        return inputTravalView
    }()
    
    private lazy var guestViewController: InputGuestViewController = {
        let guestView = InputGuestViewController()
        guestView.viewModel = viewModel?.guestViewModel
        return guestView
    }()
    
    private lazy var categoryItems: [TravalOptionType: UIViewController] = [
        .traval: travalViewController,
        .date: dateViewController,
        .guest: guestViewController
    ]
    
    private lazy var categorySort = TravalOptionType.allCases.filter {
        categoryItems.keys.contains($0)
    }
    
    private let bottomView = TravalOptionBottomView()
        
    private var currentShowingType: TravalOptionType = .traval
    var disposeBag = DisposeBag()

    func bind(to viewModel: TravalOptionViewModel) {
        Observable
            .merge(
                travalViewController.smallView.tap.map { .traval },
                dateViewController.smallView.tap.map { .date },
                guestViewController.smallView.tap.map { .guest }
            )
            .bind(to: viewModel.action.selectTravalOption)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                viewModel.state.showTravalOptionPage.map { ($0, true) },
                viewModel.state.hiddenTravalOptionPage.map { ($0, false) }
            )
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .do { vc, value in
                if value.1 {
                    vc.currentShowingType = value.0
                }
            }
            .bind(onNext: { vc, value in
                let target = vc.categoryItems[value.0] as? ViewAnimation
                vc.menuAnimate(to: target, isShow: value.1)
            })
            .disposed(by: disposeBag)
        
        viewModel.state.showTravalOptionPage
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { vc, type in
                let isShow = type != .date
                vc.menuAnimate(to: vc.bottomView, isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                closeSearchViewButton.rx.tap.map { false },
                viewModel.state.enabledSearchView.asObservable()
            )
            .withUnretained(self)
            .bind(onNext: { vc, isEnable in
                vc.closeSearchViewButton.isHidden = !isEnable
                vc.menuAnimate(to: vc.searchViewController, isShow: isEnable)
            })
            .disposed(by: disposeBag)
        
        bottomView.allRemoveButton.rx.tap
            .bind(to: viewModel.action.tappedAllRemoveButton)
            .disposed(by: disposeBag)
        
        bottomView.searchButton.rx.tap
            .bind(to: viewModel.action.tappedSearchButton)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(to: viewModel.action.tappedCloseButton)
            .disposed(by: disposeBag)
        
        viewModel.state.closedViewController
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.menuAnimate(to: vc.bottomView, isShow: false)
                let transition = TravalOptionViewTransition(.toMainView)
                vc.transitioningDelegate = transition
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .grey6
    }
    
    override func layout() {
        view.addSubview(backgroundView)
        view.addSubview(titleView)
        view.addSubview(menuStackView)
        view.addSubview(searchViewController.view)
        view.addSubview(bottomView)
        
        titleView.addSubview(closeButton)
        titleView.addSubview(closeSearchViewButton)
        
        categorySort.compactMap { categoryItems[$0] }.forEach {
            addChild($0)
            menuStackView.addArrangedSubview($0.view)
            $0.didMove(toParent: self)
        }
        
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        closeSearchViewButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-100)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.titleViewHeight)
        }
        
        menuStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            let lastMenuType = categorySort[categorySort.count - 1]
            guard let lastView = categoryItems[lastMenuType]?.view else {
                return
            }
            $0.bottom.equalTo(lastView)
        }
        
        searchViewController.view.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func menuAnimate(to target: ViewAnimation?, isShow: Bool) {
        guard let target = target else {
            return
        }
        
        if let animation = target.shouldAnimation?(isAnimate: isShow),
           !animation {
            return
        }
        
        if isShow {
            target.didShowAnimation?(safeAreaGuide: self.view.safeAreaLayoutGuide)
        } else {
            target.didHiddenAnimation?()
        }
        
        view.layoutIfNeeded()
        
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            if isShow {
                target.startShowAnimation(safeAreaGuide: self.view.safeAreaLayoutGuide)
            } else {
                target.startHiddenAnimation()
            }
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { _ in
            if isShow {
                target.finishShowAnimation?()
            } else {
                target.finishHiddenAnimation?()
            }
        }
        animator.startAnimation(afterDelay: 0)
    }
    
    func startShowAnimation() {
        viewModel?.action.startShowAnimation.accept(())
    }
}
