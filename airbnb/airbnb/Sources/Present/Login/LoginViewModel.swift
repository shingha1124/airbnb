//
//  LoginViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxRelay
import RxSwift

final class LoginViewModel: ViewModel {
    
    struct Action {
        let tappedGitHubLogin = PublishRelay<Void>()
        let inputGitHubToken = PublishRelay<String>()
    }
    
    struct State {
        let openUrl = PublishRelay<URL>()
        let dismissLoginView = PublishRelay<Void>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    @Inject(\.authRepository) private var authRepository: AuthRepository
    @Inject(\.tokenStore) private var tokenStore: TokenStore
    
    init() {
        action.tappedGitHubLogin
            .compactMap { _ -> URL? in
                let clientId = Constants.Login.gitHubClientId
                var componets = URLComponents(string: "https://github.com/login/oauth/authorize")
                componets?.queryItems = [
                    URLQueryItem(name: "client_id", value: clientId)
                ]
                
                return componets?.url
            }
            .bind(to: state.openUrl)
            .disposed(by: disposeBag)
        
        let requestGitLogin = action.inputGitHubToken
            .withUnretained(self)
            .do {
                //TODO: 로딩 인디케이터 온
            }
            .flatMapLatest { model, code in
                model.authRepository.requestGitLogin(code: code)
            }
            .do {
                //TODO: 로딩 인디케이터 오프
            }
            .share()
        
        requestGitLogin
            .compactMap { $0.value }
            .withUnretained(self)
            .do { model, token in
                model.tokenStore.store(token)
            }
            .mapVoid()
            .bind(to: state.dismissLoginView)
            .disposed(by: disposeBag)
    }
}
