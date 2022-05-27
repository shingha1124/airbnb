//
//  SearchViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import MapKit
import RxAppState
import RxDataSources
import RxSwift
import UIKit

final class SearchViewController: UIViewController {
    
    private var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "어디로 여행가세요?"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.keyboardType = .default
        searchController.searchBar.returnKeyType = .done
        return searchController
    }()
    
    private let clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "지우기"
        button.isEnabled = false
        return button
    }()
    
    private let contentView = UIView()
    
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
    
    deinit {
        Log.info("deinit SearchViewController")
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
            .bind(onNext: { vc, animated in
                vc.searchController.dismiss(animated: animated)
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
                let viewController = TravalOptionViewController(viewModel: TravalOptionViewModel(location: address))
                vc.navigationItem.backButtonTitle = ""
                vc.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        Observable
            .merge(
                NotificationCenter.default.rx.notification(UIWindow.keyboardWillShowNotification)
                    .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }.asObservable(),
                NotificationCenter.default.rx.notification(UIWindow.keyboardWillHideNotification)
                    .map { _ in 0 }.asObservable()
            )
            .withUnretained(self)
            .bind(onNext: { vc, value in
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                    vc.contentView.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(value)
                    }
                    vc.contentView.superview?.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "숙소 찾기"
        view.backgroundColor = .white
        searchController.isActive = true
    }
    
    private func layout() {
        view .addSubview(contentView)
        contentView.addSubview(arroundTravalViewController.view)
        contentView.addSubview(searchResultViewController.view)
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        arroundTravalViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchResultViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
