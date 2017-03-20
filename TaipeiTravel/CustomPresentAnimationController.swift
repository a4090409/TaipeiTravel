//
//  CustomPresentAnimationController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/23.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject,UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 2.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let fromViewcontroller = transitionContext.viewController(forKey: .from)
        let toViewcontroller = transitionContext.viewController(forKey: .to)
        let finalframFovc = transitionContext.finalFrame(for: toViewcontroller!)
        let containView = transitionContext.containerView
        let bound = UIScreen.main.bounds
        //移動到螢幕下方 toview 起始位置
        toViewcontroller?.view.frame = finalframFovc.offsetBy(dx: 0, dy: bound.size.height)
        containView.addSubview((toViewcontroller?.view)!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            fromViewcontroller?.view.alpha = 0.5
            toViewcontroller?.view.frame = finalframFovc
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
            fromViewcontroller?.view.alpha = 1.0
            
        })
    }
    
}
