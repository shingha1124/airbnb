//
//  SceneDelegate.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = RootWindow(windowScene: scene)
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url,
              url.scheme == Constants.Login.gitHubScheme,
              url.absoluteString.contains("code"),
              let code = url.absoluteString.components(separatedBy: "code=").last,
              let loginVC = window?.rootViewController?.topMost as? LoginViewController else {
            return
        }
        
        loginVC.viewModel?.action.inputGitHubToken.accept(code)
    }
}
