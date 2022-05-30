//
//  InputTravalViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import RxRelay
import RxSwift
import UIKit

protocol TestAnimate {
    func show(safeAreaGuide: UILayoutGuide)
    func hidden()
}

final class InputTravalViewController: UIViewController, TestAnimate {
    
    let smallView: NewTravalOptionMenuItemView = {
        let menuItemView = NewTravalOptionMenuItemView()
        menuItemView.title = "여행지"
        return menuItemView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isHidden = true
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행지를 알려주세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
        
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 10
        searchBar.placeholder = "여행지 검색"
        searchBar.searchTextField.backgroundColor = .clear
        return searchBar
    }()
    
    private lazy var arroundTravalViewController: ArroundTravalMiniViewController = {
        ArroundTravalMiniViewController(viewModel: viewModel.arroundTravelViewModel)
    }()
    
    private lazy var searchResultViewController: SearchResultViewController = {
        let viewController = SearchResultViewController(viewModel: viewModel.searchResultTravelViewModel)
        viewController.view.isHidden = true
        return viewController
    }()
    
    private let viewModel: InputTravalViewModelProtocol
    private let disposeBag = DisposeBag()
    public private(set) var baseHeight: CGFloat = 0
        
    init(viewModel: InputTravalViewModelProtocol) {
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

        rx.viewDidLoad
            .bind(to: viewModel.action().loadAroundTraval)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.action().inputSearctText)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    private func layout() {
        view.addSubview(smallView)
        view.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(searchBar)
        contentStackView.addArrangedSubview(arroundTravalViewController.view)

        smallView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(arroundTravalViewController.view)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        view.layoutIfNeeded()
        
        baseHeight = contentStackView.frame.minY + contentStackView.frame.height + 16
        view.snp.remakeConstraints {
            $0.bottom.equalTo(smallView).offset(16)
        }
    }
    func show(safeAreaGuide: UILayoutGuide) {
        view.snp.remakeConstraints {
            $0.bottom.equalTo(safeAreaGuide).inset(16)
        }
    }
    
    func hidden() {
        view.snp.remakeConstraints {
            $0.bottom.equalTo(smallView).offset(16)
        }
    }
}
