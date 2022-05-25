//
//  SearchViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import MapKit
import RxAppState
import RxSwift
import UIKit

final class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "어디로 여행가세요?"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        return searchController
    }()
    
    private let clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "지우기"
        button.isEnabled = false
        return button
    }()
    
    private lazy var arroundTravalViewController: ArroundTravalLargeViewController = {
        ArroundTravalLargeViewController(viewModel: viewModel.arroundTravelViewModel)
    }()
    
    private lazy var searchResultViewController: SearchResultViewController = {
        let viewController = SearchResultViewController(viewModel: viewModel.searchResultTravelViewModel)
        viewController.view.isHidden = true
        return viewController
    }()
    
    private let searchClearButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "지우기"
        return button
    }()
    
    private let viewModel: SearchViewModelProtocol
    private let disposeBag = DisposeBag()
    
    var completerResults: [MKLocalSearchCompletion]?
    
    init(viewModel: SearchViewModelProtocol) {
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
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().loadAroundTraval)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .mapVoid()
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.searchController.searchBar.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .mapVoid()
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationItem.searchController = vc.searchController
                vc.navigationItem.rightBarButtonItem = vc.clearButton
                vc.navigationItem.hidesSearchBarWhenScrolling = false
                vc.tabBarController?.tabBar.isHidden = true
            })
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.tabBarController?.tabBar.isHidden = false
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.value
            .bind(to: viewModel.action().inputSearchText)
            .disposed(by: disposeBag)

        viewModel.state().showArroundTravalView
            .bind(to: arroundTravalViewController.view.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state().showSearchResultView
            .bind(to: searchResultViewController.view.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state().enabledClearButton
            .bind(to: clearButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .bind(to: viewModel.action().clearSearchText)
            .disposed(by: disposeBag)
        
        viewModel.state().clearedSearchText
            .map { _ in "" }
            .bind(to: searchController.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state().presentSearchOption
            .withUnretained(self)
            .bind(onNext: { vc, address in
                print(address)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "숙소 찾기"
        view.backgroundColor = .white
        searchController.isActive = true
    }
    
    private func layout() {
        view.addSubview(arroundTravalViewController.view)
        view.addSubview(searchResultViewController.view)
        
        arroundTravalViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
