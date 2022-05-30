//
//  NewTravalOptionViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import RxSwift
import UIKit

final class NewTravalOptionViewController: UIViewController {
    
    enum Contants {
        static let titleViewHeight = 60.0
    }
    
    private let backgroundView: GradientView = {
        let gradientView = GradientView()
        gradientView.set(colors: [.grey4.withAlphaComponent(1), .grey4.withAlphaComponent(0.5)], startPoint: CGPoint(x: 0.5, y: 0.5), endPoint: CGPoint(x: 0.5, y: 1))
        return gradientView
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        return button
    }()
    
    private let closeSearchViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left.circle"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var inputTravalDetailView: InputTravalViewController = {
        let inputTravalView = InputTravalViewController(viewModel: viewModel.inputTravalViewModel)
        return inputTravalView
    }()
    
    private lazy var inputDateDetailView: InputTravalViewController = {
        let inputTravalView = InputTravalViewController(viewModel: viewModel.inputTravalViewModel)
        return inputTravalView
    }()
    
    private lazy var inputGuestDetailView: InputTravalViewController = {
        let inputTravalView = InputTravalViewController(viewModel: viewModel.inputTravalViewModel)
        return inputTravalView
    }()
    
    private lazy var inputPages: [NewTravalOptionType: TestAnimate] = [
        .traval: inputTravalDetailView, .date: inputDateDetailView, .guest: inputGuestDetailView,
    ]
    
    private let viewModel: NewTravalOptionViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: NewTravalOptionViewModel) {
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
        Log.info("deinit TravalOptionViewController")
    }
    
    private func bind() {
        
        rx.viewDidAppear
            .mapVoid()
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                inputTravalDetailView.smallView.tap.map { .traval },
                inputDateDetailView.smallView.tap.map { .date },
                inputGuestDetailView.smallView.tap.map { .guest }
            )
            .bind(to: viewModel.action().selectTravalOption)
            .disposed(by: disposeBag)
        
        viewModel.state().showTravalOptionPage
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { vc, type in
                vc.menuAnimate(to: type, isShow: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().hiddenTravalOptionPage
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { vc, type in
                vc.menuAnimate(to: type, isShow: false)
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func menuAnimate(to type: NewTravalOptionType, isShow: Bool) {
        guard let targetView = inputPages[type] else {
            return
        }
        UIView.animate(withDuration: 5) {
            if isShow {
                targetView.show(safeAreaGuide: self.view.safeAreaLayoutGuide)
            } else {
                targetView.hidden()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func attribute() {
        view.backgroundColor = .white.withAlphaComponent(0.3)
    }
    
    private func layout() {
        view.addSubview(backgroundView)
        view.addSubview(titleView)
        view.addSubview(categoryStackView)
        
        titleView.addSubview(closeButton)
        titleView.addSubview(closeSearchViewButton)
        
        categoryStackView.addArrangedSubview(inputTravalDetailView.view)
        categoryStackView.addArrangedSubview(inputDateDetailView.view)
        categoryStackView.addArrangedSubview(inputGuestDetailView.view)
        
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        closeSearchViewButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-100)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Contants.titleViewHeight)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(inputGuestDetailView.view)
        }
    }
}
