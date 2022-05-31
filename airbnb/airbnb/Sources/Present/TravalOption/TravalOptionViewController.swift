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
    
    private lazy var guestViewController: InputTravalViewController = {
        let inputTravalView = InputTravalViewController(viewModel: viewModel.inputTravalViewModel)
        return inputTravalView
    }()
    
    private lazy var categoryItems: [NewTravalOptionType: UIViewController] = [
        .search: searchViewController,
        .traval: travalViewController,
        .date: dateViewController
//        .guest: guestViewController
    ]
    
    private lazy var categorySort = NewTravalOptionType.allCases.filter {
        categoryItems.keys.contains($0)
    }
    
    private let viewModel: TravalOptionViewModelProtocol
    private let disposeBag = DisposeBag()
    
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
            .bind(onNext: { vc, value in
                vc.menuAnimate(to: value.0, isShow: value.1)
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().enabledSearchView
            .withUnretained(self)
            .bind(onNext: { vc, isEnable in
                vc.closeSearchViewButton.isHidden = !isEnable
                vc.menuAnimate(to: .search, isShow: isEnable)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white.withAlphaComponent(0.3)
    }
    
    private func layout() {
        view.addSubview(backgroundView)
        view.addSubview(titleView)
        view.addSubview(menuStackView)
        
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
    }
    
    private func menuAnimate(to type: NewTravalOptionType, isShow: Bool) {
        guard let targetView = categoryItems[type] as? TravalOptionAnimation else {
            return
        }
        
        if isShow {
            targetView.didShowAnimation?(safeAreaGuide: self.view.safeAreaLayoutGuide)
        } else {
            targetView.didHiddenAnimation?()
        }
        
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                if isShow {
                    targetView.startShowAnimation(safeAreaGuide: self.view.safeAreaLayoutGuide)
                } else {
                    targetView.startHiddenAnimation()
                }
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if isShow {
                    targetView.finishShowAnimation?()
                } else {
                    targetView.finishHiddenAnimation?()
                }
            })
    }
}
