//
//  SearchOptionViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import RxSwift
import UIKit

final class TravalOptionViewController: UIViewController {
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let categoryBottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let categoryItems: [OptionCategoryItem] = TravalOptionInfoType.allCases.reduce(into: []) { items, type in
        var itemView = OptionCategoryItem(type: type)
        itemView.isHidden = true
        items.append(itemView)
    }
    
    private lazy var optionViews: [TravalOptionInfoType: UIViewController] = {
        var viewControllers = [TravalOptionInfoType: UIViewController]()
        viewControllers[.checkInOut] = CheckInOutViewController(viewModel: viewModel.checkInOutViewModel)
        viewControllers[.rangePrice] = PriceViewController(viewModel: viewModel.priceViewModel)
        viewControllers[.guest] = GuestViewController(viewModel: viewModel.personViewModel)
        viewControllers.values.forEach { $0.view.isHidden = true }
        return viewControllers
    }()
    
    private let skipToolbarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem()
        buttonItem.title = "건너뛰기"
        buttonItem.setTitleTextAttributes(NSAttributedString.options([
            .foreground(color: .black),
            .font(.systemFont(ofSize: 17, weight: .medium))
        ]), for: .normal)
        return buttonItem
    }()
    
    private let resetToolbarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem()
        buttonItem.title = "지우기"
        buttonItem.setTitleTextAttributes(NSAttributedString.options([
            .foreground(color: .black),
            .font(.systemFont(ofSize: 17, weight: .medium))
        ]), for: .normal)
        return buttonItem
    }()
    
    private let nextToolbarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem()
        buttonItem.title = "다음"
        buttonItem.setTitleTextAttributes(NSAttributedString.options([
            .foreground(color: .black),
            .font(.systemFont(ofSize: 17, weight: .semibold))
        ]), for: .normal)
        buttonItem.setTitleTextAttributes(NSAttributedString.options([
            .foreground(color: .grey4),
            .font(.systemFont(ofSize: 17, weight: .semibold))
        ]), for: .disabled)
        return buttonItem
    }()
    
    private let searchToolbarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem()
        buttonItem.title = "검색"
        buttonItem.setTitleTextAttributes(NSAttributedString.options([
            .foreground(color: .black),
            .font(.systemFont(ofSize: 17, weight: .semibold))
        ]), for: .normal)
        buttonItem.setTitleTextAttributes(NSAttributedString.options([
            .foreground(color: .grey4),
            .font(.systemFont(ofSize: 17, weight: .semibold))
        ]), for: .disabled)
        return buttonItem
    }()
    
    private let contentView = UIView()
    private lazy var travalOptionToolBarButtons: [TravalOptionToolBarType: UIBarButtonItem] = [
        .skip: skipToolbarItem, .reset: resetToolbarItem,
        .next: nextToolbarItem, .search: searchToolbarItem
    ]
    
    private let viewModel: TravalOptionViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: TravalOptionViewModelProtocol) {
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
        Log.info("deinit TravalOptionViewController")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .mapVoid()
            .bind(to: viewModel.action().viewDidAppear)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { vc, animated in
                vc.navigationController?.setToolbarHidden(false, animated: animated)
            })
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
            .withUnretained(self)
            .bind(onNext: { vc, animated in
                vc.navigationController?.setToolbarHidden(true, animated: animated)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().updateToolbarButtons
            .withUnretained(self)
            .do { vc, status in
                status.forEach {
                    vc.travalOptionToolBarButtons[$0.type]?.isEnabled = $0.isEnable
                }
            }
            .compactMap { vc, status in
                status.compactMap {
                    if $0.type == .flexible {
                        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                    }
                    return vc.travalOptionToolBarButtons[$0.type]
                }
            }
            .bind(to: rx.toolbarItems)
            .disposed(by: disposeBag)
        
        viewModel.state().showCategorys
            .withUnretained(self)
            .bind(onNext: { vc, categorys in
                categorys.forEach { category in
                    vc.categoryItems[category.index].isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.state().updateTitle
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        viewModel.state().updateCategoryValue
            .withUnretained(self)
            .bind(onNext: { vc, value in
                vc.categoryItems[value.0.index].setvalue(value.1)
            })
            .disposed(by: disposeBag)
        
        let categoryTapped = Observable
            .merge( categoryItems.enumerated().map { index, view in
                view.tap
                    .compactMap {
                        TravalOptionInfoType(rawValue: index)
                    }.asObservable()
            })
            .share()
        
        categoryTapped
            .bind(to: viewModel.action().tappedCategory)
            .disposed(by: disposeBag)
        
        viewModel.state().showCategoryPage
            .filter { $0 != .location }
            .withUnretained(self)
            .do { vc, _ in
                vc.optionViews.values.forEach { $0.view.isHidden = true }
            }
            .bind(onNext: { vc, type in
                vc.optionViews[type]?.view.isHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .grey6
        hidesBottomBarWhenPushed = true
    }
    
    private func layout() {
        view.addSubview(contentView)
        view.addSubview(categoryStackView)
        
        optionViews.values.forEach {
            contentView.addSubview($0.view)
            
            $0.view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        categoryItems.forEach {
            categoryStackView.addArrangedSubview($0)
        }
        categoryStackView.addArrangedSubview(categoryBottomSeparator)
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(categoryStackView.snp.top)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryItems[0])
        }
        
        categoryBottomSeparator.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}
