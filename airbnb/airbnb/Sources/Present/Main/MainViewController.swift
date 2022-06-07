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
    
    func bind(to viewModel: MainViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.test)
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
                viewController.viewModel = TravalOptionViewModel(inputTraval: inputTraval)
                
                let transition = MainViewTransition(.toSearchView)
                viewController.modalPresentationStyle = .overFullScreen
                viewController.transitioningDelegate = transition
                vc.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(searchView)

        searchView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
