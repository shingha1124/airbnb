//
//  TravalOptionViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import RxSwift
import UIKit

final class TravalOptionViewController: UIViewController {
    
    enum Contants {
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
    
    private let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var searchViewController: InputSearchViewController = {
        let searchViewController = InputSearchViewController(viewModel: viewModel.searchViewModel)
        searchViewController.view.isHidden = true
        return searchViewController
    }()
    
    private lazy var travalViewController: InputTravalViewController = {
        let inputTravalView = InputTravalViewController(viewModel: viewModel.inputTravalViewModel)
        return inputTravalView
    }()
    
    private lazy var dateViewController: InputDateViewController = {
        let inputTravalView = InputDateViewController(viewModel: viewModel.inputDateViewModel)
        return inputTravalView
    }()
    
    private lazy var guestViewController: InputGuestViewController = {
        let guestView = InputGuestViewController(viewModel: viewModel.guestViewModel)
        return guestView
    }()
    
    private lazy var categoryItems: [NewTravalOptionType: UIViewController] = [
        .traval: travalViewController,
        .date: dateViewController,
        .guest: guestViewController
    ]
    
    private lazy var categorySort = NewTravalOptionType.allCases.filter {
        categoryItems.keys.contains($0)
    }
    
    private let bottomView = TravalOptionBottomView()
    
    var dummySearchBarFrame: UIView {
        let view = UIView()
        let frame = self.view.convert(travalViewController.contentView.frame, to: view)
        let originX = frame.origin.x + menuStackView.frame.origin.x
        let originY = frame.origin.y + menuStackView.frame.origin.y
        let searchBarFrame = CGRect(origin: CGPoint(x: originX, y: originY), size: frame.size)
        
        view.frame = searchBarFrame
        view.layer.cornerRadius = 10
        return view
    }
    
    var currentView: UIView? {
        guard let currentView = categoryItems[currentShowingType]?.view else {
            return nil
        }
        let frame = self.view.convert(currentView.frame, to: view)
        let originX = frame.origin.x + menuStackView.frame.origin.x
        let originY = frame.origin.y + menuStackView.frame.origin.y
        let searchBarFrame = CGRect(origin: CGPoint(x: originX, y: originY), size: frame.size)
        view.frame = searchBarFrame
        view.layer.cornerRadius = 10
        return view
    }
        
    private let viewModel: TravalOptionViewModelProtocol
    private let disposeBag = DisposeBag()
    private var currentShowingType: NewTravalOptionType = .traval
    
    init(viewModel: TravalOptionViewModelProtocol) {
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
        Log.info("deinit TravalOptionViewController")
    }
    
    private func bind() {
        rx.viewDidAppear
            .mapVoid()
            .bind(to: viewModel.action().viewDidAppear)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                travalViewController.smallView.tap.map { .traval },
                dateViewController.smallView.tap.map { .date },
                guestViewController.smallView.tap.map { .guest }
            )
            .bind(to: viewModel.action().selectTravalOption)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                viewModel.state().showTravalOptionPage.map { ($0, true) },
                viewModel.state().hiddenTravalOptionPage.map { ($0, false) }
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
        
        viewModel.state().showTravalOptionPage
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { vc, type in
                let isShow = type != .date
                vc.menuAnimate(to: vc.bottomView, isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let currentPage = vc.categoryItems[vc.currentShowingType] as? ViewAnimation
                vc.menuAnimate(to: currentPage, isShow: false)
                vc.menuAnimate(to: vc.bottomView, isShow: false)
                let transition = TravalOptionViewTransition(.toMainView)
                vc.transitioningDelegate = transition
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                closeSearchViewButton.rx.tap.map { false },
                viewModel.state().enabledSearchView.asObservable()
            )
            .withUnretained(self)
            .bind(onNext: { vc, isEnable in
                vc.closeSearchViewButton.isHidden = !isEnable
                vc.menuAnimate(to: vc.searchViewController, isShow: isEnable)
            })
            .disposed(by: disposeBag)
        
        bottomView.allRemoveButton.rx.tap
            .bind(to: viewModel.action().tappedAllRemoveButton)
            .disposed(by: disposeBag)
        
        bottomView.searchButton.rx.tap
            .bind(to: viewModel.action().tappedSearchButton)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white.withAlphaComponent(0.3)
    }
    
    private func layout() {
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
            $0.height.equalTo(Contants.titleViewHeight)
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
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
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
        animator.startAnimation()
    }
}
