//
//  InputTravalViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import RxRelay
import RxSwift
import UIKit

final class InputTravalViewController: UIViewController {
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let smallView: NewTravalOptionMenuItemView = {
        let menuItemView = NewTravalOptionMenuItemView()
        menuItemView.title = "여행지"
        return menuItemView
    }()
    
    private let largeView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alpha = 0
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행지를 알려주세요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
        
    private let searchBarView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let searchBarIcon: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "magnifyingglass")
        imageView.image = image
        imageView.tintColor = .grey1
        return imageView
    }()
    
    private let searchBarLabel: UILabel = {
        let label = UILabel()
        label.text = "여행지 검색"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let searchBarButton = UIButton()
    
    private lazy var arroundTravalViewController: ArroundTravalMiniViewController = {
        ArroundTravalMiniViewController(viewModel: viewModel.arroundTravelViewModel)
    }()
    
    private let viewModel: InputTravalViewModelProtocol
    private let disposeBag = DisposeBag()
        
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
        
        searchBarButton.rx.tap
            .bind(to: viewModel.action().tappedSearchBar)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
    }
    
    private func layout() {
        addChild(arroundTravalViewController)
        
        view.addSubview(contentView)
        
        contentView.addSubview(smallView)
        contentView.addSubview(largeView)

        searchBarView.addSubview(searchBarIcon)
        searchBarView.addSubview(searchBarLabel)
        searchBarView.addSubview(searchBarButton)

        largeView.addArrangedSubview(titleLabel)
        largeView.addArrangedSubview(searchBarView)
        largeView.addArrangedSubview(arroundTravalViewController.view)
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(contentView)
        }

        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(smallView)
        }

        smallView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }

        largeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(arroundTravalViewController.view)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        searchBarView.snp.makeConstraints {
            $0.height.equalTo(50)
        }

        searchBarIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }

        searchBarLabel.snp.makeConstraints {
            $0.leading.equalTo(searchBarIcon.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }

        searchBarButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension InputTravalViewController: TravalOptionAnimation {
    func startShowAnimation(safeAreaGuide: UILayoutGuide) {
        smallView.alpha = 0
        largeView.alpha = 1
        
        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(largeView).offset(16)
        }
    }
    
    func startHiddenAnimation() {
        smallView.alpha = 1
        largeView.alpha = 0
        
        contentView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(smallView)
        }
    }
}
