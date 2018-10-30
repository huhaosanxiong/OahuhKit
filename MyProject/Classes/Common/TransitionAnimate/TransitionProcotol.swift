//
//  TransitionProcotol.swift
//  MyProject
//
//  Created by 胡浩三雄 on 2018/10/29.
//  Copyright © 2018 胡浩三雄. All rights reserved.
//

import UIKit

class TransitionProcotol: NSObject, UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return PushAnimation()
        }else {
            return PopAnimation()
        }
    }
}
