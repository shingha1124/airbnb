//
//  InputSearchViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import RxSwift
import UIKit

final class InputSearchViewController: UIViewController {
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let searchBar: UISearchTextField = {
        let textField = UISearchTextField()
        textField.leftView?.tintColor = .black
        textField.backgroundColor = .grey6
        return textField
    }()
    
    private lazy var searchResultViewController: SearchResultViewController = {
        let viewController = SearchResultViewController(viewModel: viewModel.searchResultTravelViewModel)
        return viewController
    }()
    
    private let viewModel: InputSearchViewModelProtocol
    private let disposeBag = DisposeBag()
        
    init(viewModel: InputSearchViewModelProtocol) {
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
        Log.info("deinit InputTravalViewController")
    }
    
    private func bind() {
        searchBar.rx.text
            .bind(to: viewModel.action().inputSearchText)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                NotificationCenter.keyboardWillShowHeight,
                NotificationCenter.keyboardWillHideHeight
            )
            .withUnretained(self)
            .bind(onNext: { vc, value in
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                    vc.searchResultViewController.view.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(value)
                    }
                    vc.searchResultViewController.view.superview?.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
    }
    
    private func layout() {
        addChild(searchResultViewController)
        view.addSubview(contentView)
        
        contentView.addSubview(searchBar)
        contentView.addSubview(searchResultViewController.view)
         
        view.snp.makeConstraints {
            $0.bottom.equalTo(contentView)
        }

        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(1000)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        searchResultViewController.view.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}

extension InputSearchViewController: TravalOptionAnimation {
    func didShowAnimation(safeAreaGuide: UILayoutGuide) {
        view.isHidden = false
        
        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(safeAreaGuide)
        }
        
        view.superview?.layoutIfNeeded()
    }
    
    func startShowAnimation(safeAreaGuide: UILayoutGuide) {
        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaGuide)
        }
    }
    
    func finishShowAnimation() {
        searchBar.becomeFirstResponder()
    }
    
    func startHiddenAnimation() {
//        smallView.alpha = 1
//        largeView.alpha = 0
//        contentView.snp.remakeConstraints {
//            $0.bottom.equalTo(smallView)
//        }
    }
}
