//
//  TravalOptionViewTransition.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/02.
//

import UIKit

class TravalOptionViewTransition: NSObject, UIViewControllerTransitioningDelegate {
    enum `Type` {
        case toMainView
    }
    
    private let transitionType: `Type`
    
    init(_ transitionType: `Type`) {
        self.transitionType = transitionType
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch transitionType {
        case .toMainView:
            return TravalOptionViewAnimatedTransitioning()
        }
    }
}
class TravalOptionViewAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
        
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? TravalOptionViewController else {
            return
        }
        
        fromVC.view.alpha = 1
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            fromVC.view.alpha = 0
            fromVC.view.frame.size = CGSize(width: fromVC.view.frame.size.width, height: 100)
        }
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
        
        animator.startAnimation()
    }
}
