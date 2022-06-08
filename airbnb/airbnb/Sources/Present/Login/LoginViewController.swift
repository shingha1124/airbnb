//
//  LoginViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import RxSwift
import UIKit

final class LoginViewController: BaseViewController, View {
    
    private let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light, scale: .large)
        let image = UIImage(systemName: "xmark", withConfiguration: largeConfig)
        let normalImage = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(normalImage, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let gitLoginButton: LoginButtonView = {
        let button = LoginButtonView()
        button.text = "깃허브 계정으로 로그인"
        button.buttonColor = .grey2
        button.image = UIImage(named: "ic_github")?.withTintColor(.white)
        return button
    }()
    
    private let topViewSeperation: UIView = {
        let view = UIView()
        view.backgroundColor = .grey5
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LoginViewModel) {
        
        gitLoginButton.loginButton.rx.tap
            .bind(to: viewModel.action.tappedGitHubLogin)
            .disposed(by: disposeBag)
        
        viewModel.state.openUrl
            .bind(onNext: { url in
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                closeButton.rx.tap.asObservable(),
                viewModel.state.dismissLoginView.asObservable()
            )
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(topView)
        view.addSubview(gitLoginButton)
        
        topView.addSubview(titleLabel)
        topView.addSubview(closeButton)
        topView.addSubview(topViewSeperation)
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        topViewSeperation.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        gitLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
}
