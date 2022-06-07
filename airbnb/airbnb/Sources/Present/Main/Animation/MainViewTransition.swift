//
//  MainViewPresentAnimation.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/02.
//

import UIKit

class MainViewTransition: NSObject, UIViewControllerTransitioningDelegate {
    enum `Type` {
        case toSearchView
    }
    
    private let transitionType: `Type`
    
    init(_ transitionType: `Type`) {
        self.transitionType = transitionType
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch transitionType {
        case .toSearchView:
            return MainViewAnimatedTransitioning()
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
}

class MainViewAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
        
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let tabbarController = transitionContext.viewController(forKey: .from) as? MainTabBarController
        
        guard let mainView = tabbarController?.children[0] as? MainViewController,
            let travalOptionView = transitionContext.viewController(forKey: .to) as? TravalOptionViewController else {
            return
        }
        
        let fromSearchView = mainView.searchView.contentView
        
        guard let snapshotSearchBarView = fromSearchView.snapshotView(afterScreenUpdates: false) else {
            return
        }
        fromSearchView.alpha = 0
        
        let containerView = transitionContext.containerView
        snapshotSearchBarView.frame = containerView.convert(fromSearchView.frame, to: mainView.view)
        
        containerView.addSubview(travalOptionView.view)
        containerView.addSubview(snapshotSearchBarView)

        travalOptionView.view.alpha = 0
        snapshotSearchBarView.alpha = 1

        travalOptionView.view.layoutIfNeeded()
        
        let targetMenuView = travalOptionView.travalViewController.contentView
        let travalOptionMenuView = travalOptionView.menuStackView
        let targetFrame = containerView.convert(targetMenuView.frame, from: travalOptionMenuView)
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotSearchBarView.frame = targetFrame
            travalOptionView.view.alpha = 1
            snapshotSearchBarView.alpha = 0
        }
        
        animator.addCompletion { position in
            travalOptionView.view.alpha = 1
            fromSearchView.alpha = 1
            snapshotSearchBarView.removeFromSuperview()
            travalOptionView.test()
        }
        
        transitionContext.completeTransition(true)
        animator.startAnimation()
    }
}
