//
//  CalenderViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import RxSwift
import UIKit

final class GuestViewController: BaseViewController, View {
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: GuestViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state.guestViewModels
            .withUnretained(self)
            .bind(onNext: { vc, viewModels in
                viewModels.forEach {
                    let guestItemView = GuestOptionItemView(viewModel: $0)
                    vc.contentStackView.addArrangedSubview(guestItemView)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        view.snp.makeConstraints {
            $0.bottom.equalTo(contentStackView)
        }
    }
}
