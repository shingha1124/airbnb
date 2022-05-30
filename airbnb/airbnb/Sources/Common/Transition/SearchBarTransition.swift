//
//  SearchBarTransition.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/30.
//

import UIKit

class SearchBarNavigationTransition: NSObject, UINavigationControllerDelegate {
    
    private let transition = SearchBarAnimated(.present)
    
    init(searchBar: UIView) {
//        transition.setFrame(searchBar.frame)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

class SearchBarTransition: NSObject, UIViewControllerTransitioningDelegate {
    private let transition: SearchBarAnimated
    
    init(searchBar: UIView) {
        transition = SearchBarAnimated(.present)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition
    }
}

class SearchBarAnimated: NSObject, UIViewControllerAnimatedTransitioning {
    enum PresentType {
        case present, dismiss
    }
    
    private let presentType: PresentType
    
    init(_ presentType: PresentType) {
        self.presentType = presentType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) as? NewTravalOptionViewController else {
            return
        }
        containerView.addSubview(toVC.view)
//        fromVC.view.alpha = 1
        toVC.view.transform = CGAffineTransform(translationX: 0, y: -100)
        toVC.view.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
//            fromVC.view.alpha = 0.5
//            fromVC.view.transform = CGAffineTransform(translationX: 0, y: 100)
            
            toVC.view.transform = .identity
            toVC.view.alpha = 1
        }, completion: { _ in
//            fromVC.view.alpha = 1
//            fromVC.view.transform = .identity
        })
        transitionContext.completeTransition(true)
    }
}
