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
        return stackView
    }()
    
    private let categoryItems: [OptionCategoryItem] = TravalOptionInfo.OptionType.allCases.reduce(into: []) { items, type in
        var itemView = OptionCategoryItem(type: type)
        itemView.isHidden = true
        items.append(itemView)
    }
    
    private lazy var optionViews: [TravalOptionInfo.OptionType: UIViewController] = {
        var viewControllers = [TravalOptionInfo.OptionType: UIViewController]()
        viewControllers[.checkInOut] = CheckInOutViewController(viewModel: viewModel.checkInOutViewModel)
        viewControllers[.rangePrice] = PriceViewController(viewModel: viewModel.priceViewModel)
        viewControllers[.person] = GuestViewController(viewModel: viewModel.personViewModel)
        viewControllers.values.forEach { $0.view.isHidden = true }
        return viewControllers
    }()
    
    private let contentView = UIView()
    
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
        
        viewModel.state().usingCategorys
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
        
        viewModel.state().updateValue
            .withUnretained(self)
            .bind(onNext: { vc, value in
                vc.categoryItems[value.0.index].setvalue(value.1)
            })
            .disposed(by: disposeBag)
        
        let categoryTapped = Observable
            .merge( categoryItems.enumerated().map { index, view in
                view.tap
                    .compactMap {
                        TravalOptionInfo.OptionType(rawValue: index)
                    }.asObservable()
            })
            .share()
        
        Observable
            .merge(
                viewModel.state().showCategoryPage.asObservable(),
                categoryTapped
            )
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
        view.backgroundColor = .white
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
    }
}
