//
//  VGViewControllerAnimatedTransitioning.swift
//  Custom Transations
//
//  Created by Victor Gabana on 24/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

class VGViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationDuration : NSTimeInterval = 1
    private let isPresenting :Bool
    
    // MARK: - Life cycle
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning protocol
    
    /// This method returns the time that the animation will take (without considering interactive transitions, even if they are implemented). Must be the same value that is used in the animations of the following method (animateTransition:).
    /// This value is used to synch other animations like by instance change the nabvigation bar in the navigation controller or make some other change in custom container view controllers.
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.animationDuration
    }
    
    /// This method is called when presenting or dismissing a view controller.
    /// All animations must take place in the containerView of transitionContext. Add the view being presented or revelaned to it and perform your animations
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }
    
    /// This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
    /// It is called at the end of a transition to let you know the results. Use this method to perform any final cleanup operations required by your transition animator when the transition finishes.
//    optional func animationEnded(transitionCompleted: Bool)
    
    // MARK: - Custom animation methods
    
    private func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        // Gettting the view controllers and views
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else { return }
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else { return }
        guard let containerView = transitionContext.containerView() else { return }
        
        toView.layer.anchorPoint = CGPointMake(0.5, 0.0)
        // Position the presented view off the top of the container view
        toView.frame = transitionContext.finalFrameForViewController(toViewController)
        
        // Displacement
        let verticalDisplacement  = CGFloat(100)
        toView.center.y -= verticalDisplacement
        
        // Transformation
        var viewToTransform: CATransform3D = CATransform3DMakeRotation(CGFloat(M_PI_2), 1.0, 0.0, 0.0)
        // Giving it some perspective
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
    
    private func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        // Gettting the view controllers and views
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else { return }
        
        // Animate the presented view off the bottom of the view
        UIView.animateWithDuration(self.animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            
            fromView.frame.origin.y = -fromView.bounds.height
            
            }, completion: {(completed: Bool) -> Void in
                
                if transitionContext.transitionWasCancelled() {
                    transitionContext.completeTransition(false)
                } else {
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
        })
    }
}
