//
//  VGViewControllerAnimatedTransitioning.swift
//  Custom Transations
//
//  Created by Victor Gabana on 24/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

class VGViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationDuration : NSTimeInterval = 1
    let isPresenting :Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning protocol
    
    /// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to synchronize with the main animation.
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.animationDuration
    }
    
    /// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    /// This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
//    optional func animationEnded(transitionCompleted: Bool)
    
    // MARK: - Custom animation methods
    
    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        // Gettting the view controllers and views
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let containerView = transitionContext.containerView()!
        
        toView.layer.anchorPoint = CGPointMake(0.5, 0.0)
        // Position the presented view off the top of the container view
        toView.frame = transitionContext.finalFrameForViewController(toViewController)
        
        // Displacement
        let verticalDisplacement  = CGFloat(100)
        toView.center.y -= verticalDisplacement
        
        // Trnasformation
        var viewToTransform: CATransform3D = CATransform3DMakeRotation(CGFloat(M_PI_2), 1.0, 0.0, 0.0)
        // Giving some perspective
        viewToTransform.m34 = CGFloat(0.001)
        toView.layer.transform = viewToTransform
        
        // Add toView to the container view
        containerView.addSubview(toView)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            toView.center.y += verticalDisplacement
            toView.layer.transform = CATransform3DIdentity
            
            }) { (completed: Bool) -> Void in
            
                toView.layer.transform = CATransform3DIdentity
                
                if transitionContext.transitionWasCancelled() {
                    toView.removeFromSuperview()
                    transitionContext.completeTransition(false)
                } else {
                    transitionContext.completeTransition(true)
                }
        }
    }
    
    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()!
        
        // Animate the presented view off the bottom of the view
        UIView.animateWithDuration(self.animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            
            fromView.center.y -= containerView.bounds.size.height
            
            }, completion: {(completed: Bool) -> Void in
                
                if transitionContext.transitionWasCancelled() {
                    transitionContext.completeTransition(false)
                    print("dismissal animation canceled")
                } else {
                    print("dismissal animation completed")
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
        })
    }
}
