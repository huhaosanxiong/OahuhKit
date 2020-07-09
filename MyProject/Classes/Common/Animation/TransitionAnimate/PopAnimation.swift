//
//  PopAnimation.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/29.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var context: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        context = transitionContext
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PopTransitionViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? PushTransitionViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        let container = transitionContext.containerView
        
        let tempView = container.subviews.last
        
//        container.addSubview(toVC.view)
//        container.addSubview(fromVC.view)

        
        toVC.label.isHidden = true
        fromVC.label.isHidden = true
        tempView?.isHidden = false
        container.insertSubview(toVC.view, at: 0)
        
        
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            tempView?.frame = toVC.label.frame
        }) { success in
            toVC.label.isHidden = false
            tempView?.removeFromSuperview()
        }
        
        
        let toButton = toVC.pushButton
        
        let maxX = toButton.frame.origin.x > toVC.view.bounds.width/2.0 ? toButton.frame.origin.x : toVC.view.bounds.width - toButton.frame.origin.x
        let maxY = toButton.frame.origin.y > toVC.view.bounds.height/2.0 ? toButton.frame.origin.y : toVC.view.bounds.height - toButton.frame.origin.y
        
        let radius = sqrt(maxX*maxX + maxY*maxY)
        
        //Starting path
        let maskStartPath = UIBezierPath.init(ovalIn: toButton.frame.insetBy(dx: -radius, dy: -radius))
        
        //Destination path
        let maskFinalPath = UIBezierPath.init(ovalIn: toButton.frame)
        
        
        //mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskFinalPath.cgPath
        fromVC.view.layer.mask = maskLayer
        
        //mask animation
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartPath.cgPath
        maskLayerAnimation.toValue = maskFinalPath.cgPath
        maskLayerAnimation.duration = transitionDuration(using: context)
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "pingInvert")
        
        
    }

}

extension PopAnimation: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        context?.completeTransition(true)
        context?.viewController(forKey: .from)?.view.layer.mask = nil
        context?.viewController(forKey: .to)?.view.layer.mask = nil
    }
}
