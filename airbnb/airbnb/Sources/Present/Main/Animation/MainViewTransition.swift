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
    
    private let duration = 0.3
    
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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = snapshotSearchBarView.backgroundColor
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = snapshotSearchBarView.layer.cornerRadius
        backgroundView.addSubview(snapshotSearchBarView)
        
        let containerView = transitionContext.containerView
        backgroundView.frame = containerView.convert(fromSearchView.frame, to: mainView.view)
        
        containerView.addSubview(travalOptionView.view)
        containerView.addSubview(backgroundView)
        
        travalOptionView.view.alpha = 0
        backgroundView.alpha = 1
        
        travalOptionView.view.layoutIfNeeded()
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            let toTargetView = travalOptionView.dummySearchBarFrame
            backgroundView.frame = toTargetView.frame
            backgroundView.layer.cornerRadius = toTargetView.layer.cornerRadius
            travalOptionView.view.alpha = 1
            backgroundView.alpha = 0
        }
        
        animator.addCompletion { position in
            travalOptionView.view.alpha = 1
            backgroundView.removeFromSuperview()
        }
        
        transitionContext.completeTransition(true)
        animator.startAnimation()
    }
}
