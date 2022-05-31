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
        transition
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
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? NewTravalOptionViewController else {
            return
        }
        containerView.addSubview(toVC.view)
        toVC.view.transform = CGAffineTransform(translationX: 0, y: -100)
        toVC.view.alpha = 0
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                toVC.view.transform = .identity
                toVC.view.alpha = 1
            },
            completion: { _ in
            })
        transitionContext.completeTransition(true)
    }
}
