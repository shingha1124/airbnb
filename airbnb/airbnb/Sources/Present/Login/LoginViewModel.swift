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
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
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
        
        action.inputGitHubToken
            .bind(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
