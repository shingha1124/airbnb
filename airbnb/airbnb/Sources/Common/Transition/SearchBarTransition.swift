//
//  SearchBarTransition.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import UIKit

class SearchBarAnimated: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let viewAnimation: ViewAnimation
    
    init(_ viewAnimation: ViewAnimation) {
        self.viewAnimation = viewAnimation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? TravalOptionViewController else {
            return
        }
        containerView.addSubview(toVC.view)
        toVC.view.transform = CGAffineTransform(translationX: 0, y: -100)
        toVC.view.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            toVC.view.transform = .identity
            toVC.view.alpha = 1
        }
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
    }
}
