//
//  RootWindow.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import RxSwift
import UIKit

class RootWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        overrideUserInterfaceStyle = .light
        let mapLodgingViewController = MapLodgingViewController()
        mapLodgingViewController.viewModel = MapLodgingViewModel()
        rootViewController = mapLodgingViewController
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
}
