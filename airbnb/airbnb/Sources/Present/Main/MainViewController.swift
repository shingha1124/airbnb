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
    
    private lazy var lodgingListViewController: LodgingListViewController = {
        let viewController = LodgingListViewController()
        viewController.viewModel = viewModel?.lodgingListViewModel
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
    }
    
    override func layout() {
        addChild(lodgingListViewController)
        lodgingListViewController.didMove(toParent: self)
        
        view.addSubview(searchView)
        view.addSubview(lodgingListViewController.view)

        searchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        lodgingListViewController.view.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func searchAction(_ searchData: TravalSearchData) {
        viewModel?.action.searchLodgingList.accept(searchData)
    }
}
