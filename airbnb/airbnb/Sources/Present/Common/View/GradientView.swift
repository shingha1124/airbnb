//
//  GradientView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/26.
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    func set(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = colors.compactMap { $0.cgColor }
        gradientLayer?.startPoint = startPoint
        gradientLayer?.endPoint = endPoint
    }
}
