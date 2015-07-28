//
//  TransitioningDelegate.swift
//  Custom Transations
//
//  Created by Victor Gabana on 28/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

class VGTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
            // Our view controller can now provide an instance of our UIPresentationController class whenever it's presented...
            return VGPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return VGViewControllerAnimatedTransitioning(isPresenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return VGViewControllerAnimatedTransitioning(isPresenting: false)
    }
    
    //    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    
    //    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
}