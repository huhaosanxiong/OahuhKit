//
//  PushAnimation.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/29.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var context: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        context = transitionContext
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PushTransitionViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? PopTransitionViewController else {
                transitionContext.completeTransition(false)
            return
        }
        
        let container = transitionContext.containerView
        
        guard let tempView = fromVC.label.snapshotView(afterScreenUpdates: false) else {
            return
        }
        tempView.frame = fromVC.label.convert(fromVC.label.bounds, to: container)
        
        fromVC.label.isHidden = true
        toVC.label.isHidden = true
        
        container.addSubview(toVC.view)
        container.addSubview(tempView)
        
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            tempView.frame = toVC.label.convert(toVC.label.bounds, to: toVC.view)
        }) { success in
            tempView.isHidden = true
            toVC.label.isHidden = false
        }
        
        let fromButton = fromVC.pushButton
        
        //Starting path
        let maskStartPath = UIBezierPath.init(ovalIn: fromButton.frame)
        
        //Destination path
        let maxX = fromButton.frame.origin.x > toVC.view.bounds.width/2.0 ? fromButton.frame.origin.x : toVC.view.bounds.width - fromButton.frame.origin.x
        let maxY = fromButton.frame.origin.y > toVC.view.bounds.height/2.0 ? fromButton.frame.origin.y : toVC.view.bounds.height - fromButton.frame.origin.y
        
        //实际就是button距离屏幕四个角的最大距离
        let radius = sqrt((maxX*maxX) + (maxY*maxY))
        
        let finalMaskPath = UIBezierPath(ovalIn: fromButton.frame.insetBy(dx: -radius, dy: -radius))
        
        //Actual mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalMaskPath.cgPath
        toVC.view.layer.mask = maskLayer
        
        //Mask Animation
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartPath.cgPath
        maskLayerAnimation.toValue = finalMaskPath.cgPath
        maskLayerAnimation.delegate = self
        maskLayerAnimation.duration = transitionDuration(using: context)
        maskLayer.add(maskLayerAnimation, forKey: "path")
        
    }
    

}

extension PushAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        context?.completeTransition(true)
        context?.viewController(forKey: .from)?.view.layer.mask = nil
        context?.viewController(forKey: .to)?.view.layer.mask = nil
    }
}
