//
//  LoginViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import RxSwift
import UIKit

final class LoginViewController: BaseViewController, View {
    
    private let gitLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LoginViewModel) {
        
        gitLoginButton.rx.tap
            .bind(to: viewModel.action.tappedGitHubLogin)
            .disposed(by: disposeBag)
        
        viewModel.state.openUrl
            .bind(onNext: { url in
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        viewModel.state.dismissLoginView
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(gitLoginButton)
        
        gitLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
}
