//
//  MainViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxAppState
import RxSwift
import UIKit

final class MainViewController: UIViewController {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey6
        return view
    }()
    
    private let searchBarView: SearchBarView = {
        let searchView = SearchBarView(isUseTapped: true)
        return searchView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()
    
    private let heroImageView = HeroImageView()
    
    private lazy var arroundTravalViewController: ArroundTravalMiniViewController = {
        ArroundTravalMiniViewController(viewModel: viewModel.arroundTravelViewModel)
    }()
    
    private lazy var recommandTravelViewController: RecommandTravelViewController = {
        RecommandTravelViewController(viewModel: viewModel.recommandTravelViewModel)
    }()
    
    private let viewModel: MainViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().loadHome)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, animated in
                vc.navigationController?.setNavigationBarHidden(true, animated: animated)
            })
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
            .withUnretained(self)
            .bind(onNext: { vc, animated in
                vc.navigationController?.setNavigationBarHidden(false, animated: animated)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().loadedHeroImage
            .bind(onNext: heroImageView.setImage)
            .disposed(by: disposeBag)
        
        searchBarView.tapped
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let viewController = SearchViewController(viewModel: SearchViewModel())
                vc.navigationItem.backButtonTitle = ""
                vc.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(heroImageView)
        contentStackView.addArrangedSubview(arroundTravalViewController.view)
        contentStackView.addArrangedSubview(recommandTravelViewController.view)
        
        view.addSubview(headerView)
        headerView.addSubview(searchBarView)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(searchBarView)
        }
        
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentStackView).offset(48)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
