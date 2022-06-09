//
//  MainViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxAppState
import RxSwift
import UIKit

class MainViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    let searchView: MainSearchBarView = {
        let view = MainSearchBarView()
        return view
    }()
    
    private let showListViewButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(NSAttributedString.create("목록", options: [.font(.systemFont(ofSize: 17, weight: .semibold))]))
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .grey1
        config.image = UIImage(named: "ic_list")?.withTintColor(.white)
        config.imagePadding = 8
        
        let button = UIButton(configuration: config)
        button.isHidden = true
        return button
    }()
    
    private let showMapViewButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(NSAttributedString.create("지도", options: [.font(.systemFont(ofSize: 17, weight: .semibold))]))
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .grey1
        config.image = UIImage(named: "ic_map")?.withTintColor(.white)
        config.imagePadding = 8
        
        let button = UIButton(configuration: config)
        button.isHidden = false
        return button
    }()
    
    private lazy var lodgingListViewController: LodgingListViewController = {
        let viewController = LodgingListViewController()
        viewController.viewModel = viewModel?.lodgingListViewModel
        return viewController
    }()
    
    private lazy var mapViewController: MapViewController = {
        let viewController = MapViewController()
        viewController.viewModel = viewModel?.mapViewModel
        return viewController
    }()
    
    func bind(to viewModel: MainViewModel) {
        
        rx.viewDidLoad
            .mapVoid()
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.navigationController?.setNavigationBarHidden(true, animated: false)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                searchView.searchButton.rx.tap.map { "" }.asObservable()
            )
            .withUnretained(self)
            .bind(onNext: { vc, inputTraval in
                let viewController = TravalOptionViewController()
                viewController.viewModel = TravalOptionViewModel(inputTraval: inputTraval, searchAction: vc.searchAction)
                
                let transition = MainViewTransition(.toSearchView)
                viewController.modalPresentationStyle = .overFullScreen
                viewController.transitioningDelegate = transition
                vc.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.state.presentLoginView
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let viewController = LoginViewController()
                viewController.viewModel = LoginViewModel()
                viewController.modalPresentationStyle = .pageSheet
                vc.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                showListViewButton.rx.tap.map { true },
                showMapViewButton.rx.tap.map { false }
            )
            .withUnretained(self)
            .bind(onNext: { vc, isShowListView in
                vc.showListViewButton.isHidden = isShowListView
                vc.showMapViewButton.isHidden = !isShowListView
                vc.lodgingListViewController.view.isHidden = !isShowListView
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        addChild(lodgingListViewController)
        lodgingListViewController.didMove(toParent: self)
        addChild(mapViewController)
        mapViewController.didMove(toParent: self)
        
        view.addSubview(mapViewController.view)
        view.addSubview(lodgingListViewController.view)
        view.addSubview(searchView)
        view.addSubview(showListViewButton)
        view.addSubview(showMapViewButton)
        
        searchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        mapViewController.view.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        lodgingListViewController.view.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        showListViewButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(90)
            $0.height.equalTo(38)
        }
        
        showMapViewButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(90)
            $0.height.equalTo(38)
        }
    }
    
    private func searchAction(_ searchData: TravalSearchData) {
        viewModel?.action.searchLodgingList.accept(searchData)
    }
}
