//
//  WishListViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxSwift
import UIKit

final class WishListViewController: BaseViewController, View {
    private let loginPageView: WishLoginPageView = {
        let loginView = WishLoginPageView()
        loginView.isHidden = true
        return loginView
    }()
    
    private lazy var wishListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(WishListViewCell.self, forCellReuseIdentifier: WishListViewCell.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: WishListViewModel) {
        rx.viewDidAppear
            .mapVoid()
            .bind(to: viewModel.action.checkLogin)
            .disposed(by: disposeBag)
        
        viewModel.state.isLogin
            .bind(to: loginPageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state.isLogin
            .map { !$0 }
            .bind(to: wishListTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.state.isLogin
            .map { $0 ? "위시리스트" : "" }
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        loginPageView.loginButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let viewController = LoginViewController()
                viewController.viewModel = LoginViewModel()
                viewController.delegate = self
                viewController.modalPresentationStyle = .pageSheet
                vc.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.state.updateWishList
            .bind(to: wishListTableView.rx.items(cellIdentifier: WishListViewCell.identifier, cellType: WishListViewCell.self)) { _, model, cell in
                cell.viewModel = model
            }
            .disposed(by: disposeBag)
        
        viewModel.state.presentDetailView
            .withUnretained(self)
            .bind(onNext: { vc, id in
//                let viewController = DetailViewController(
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(wishListTableView)
        view.addSubview(loginPageView)
        
        loginPageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        wishListTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension WishListViewController: LoginViewControllerDelegate {
    func viewWillDisappear() {
        viewModel?.action.checkLogin.accept(())
    }
}
