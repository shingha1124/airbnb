//
//  InputSearchViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/31.
//

import RxSwift
import UIKit

final class InputSearchViewController: BaseViewController, View {
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
        textField.returnKeyType = .search
        return textField
    }()
    
    private lazy var searchResultViewController: SearchResultViewController = {
        let viewController = SearchResultViewController()
        viewController.viewModel = viewModel?.searchResultViewModel
        return viewController
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: InputSearchViewModel) {
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
        
        searchBar.rx.text
            .bind(to: viewModel.action.inputSearchText)
            .disposed(by: disposeBag)
        
        searchBar.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(searchBar.rx.text)
            .bind(to: viewModel.action.editingDidEndOnExit)
            .disposed(by: disposeBag)
    }
    
    override func layout() {
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

extension InputSearchViewController: ViewAnimation {
    
    private func startPosition() {
        searchBar.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        contentView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func endPosition(safeAreaGuide: UILayoutGuide) {
        searchBar.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        contentView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func startShowAnimation(safeAreaGuide: UILayoutGuide) {
        endPosition(safeAreaGuide: safeAreaGuide)
    }
    
    func didShowAnimation(safeAreaGuide: UILayoutGuide) {
        view.isHidden = false
        startPosition()
    }
    
    func finishShowAnimation() {
        searchBar.becomeFirstResponder()
    }
    
    func didHiddenAnimation() {
        searchBar.resignFirstResponder()
    }
    
    func startHiddenAnimation() {
        startPosition()
    }
    
    func finishHiddenAnimation() {
        view.isHidden = true
    }
}
