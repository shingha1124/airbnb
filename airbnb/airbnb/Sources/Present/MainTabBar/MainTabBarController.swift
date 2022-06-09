//
//  MainTabBarController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import SnapKit
import UIKit

final class MainTabBarController: UITabBarController {
    
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        setUpTabBar()
    }
    
    private func attribute() {
        view.backgroundColor = .white
        tabBar.tintColor = .grey1
        tabBar.unselectedItemTintColor = .grey3
        tabBar.backgroundColor = .grey6
    }
    
    private func layout() {
        tabBar.addSubview(topBarView)
        
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func setUpTabBar() {
        let mainViewController = MainViewController()
        mainViewController.viewModel = MainViewModel()
        mainViewController.tabBarItem.title = "검색"
        mainViewController.tabBarItem.image = UIImage(named: "ic_search")
        
        let wishListViewController = WishListViewController()
        wishListViewController.tabBarItem.title = "위시리스트"
        wishListViewController.tabBarItem.image = UIImage(named: "ic_heart")
        
        let myReservationViewController = MapViewController()
        myReservationViewController.viewModel = MapViewModel()
        myReservationViewController.tabBarItem.title = "내 예약"
        myReservationViewController.tabBarItem.image = UIImage(named: "ic_user")
        
        viewControllers = [
            mainViewController, wishListViewController, myReservationViewController
        ]
    }
}
