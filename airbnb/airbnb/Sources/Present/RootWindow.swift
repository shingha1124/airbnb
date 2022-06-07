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
        
//        let viewModel = SearchResultViewModel()
//        let testView = SearchResultViewController(viewModel: viewModel)
//        viewModel.action().inputSearchText.accept("서울")
        
//        let viewModel = CheckInOutViewModel()
//        let viewController = CheckInOutViewController(viewModel: viewModel)
        
        let viewModel = GuestViewModel(guestMax: 20, babyMax: 10)
        let viewController = GuestViewController(viewModel: viewModel)
    
        rootViewController = MainTabBarController()
        //ArroundTravalLargeViewController(viewModel: ArroundTravalViewModel())
        //PriceViewController(viewModel: PriceViewModel())
        //MainTabBarController()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
}
