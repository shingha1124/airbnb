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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "어디로 여행가세요?"
        return searchBar
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
    
    deinit {
        Log.info("deinit MainViewController")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().loadHome)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .grey6
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

                vc.navigationController?.navigationBar.tintColor = .black
                vc.navigationController?.navigationBar.standardAppearance = appearance
                vc.navigationController?.navigationBar.compactAppearance = appearance
                vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
                vc.navigationItem.titleView = vc.searchBar
            })
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
            .map { _ in nil }
            .bind(to: navigationItem.rx.titleView)
            .disposed(by: disposeBag)
        
        viewModel.state().loadedHeroImage
            .bind(onNext: heroImageView.setImage)
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .withUnretained(self)
            .do { vc, _ in
                vc.searchBar.resignFirstResponder()
            }
            .bind(onNext: { vc, _ in
                let viewController = SearchViewController(viewModel: SearchViewModel())
                vc.navigationItem.backButtonTitle = ""
                vc.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().presentSearchOption
            .withUnretained(self)
            .bind(onNext: { vc, address in
                let viewController = TravalOptionViewController(viewModel: TravalOptionViewModel(location: address))
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
