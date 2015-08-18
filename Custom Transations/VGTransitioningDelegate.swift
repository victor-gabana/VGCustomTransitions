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
    
    // MARK: Interactive transition
    
    let percentDrivenIteratactiveTransition = VGPercentDrivenInteractiveTransition()
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        if let presentingViewController = self.interactiveViewController.presentingViewController {
            
            self.percentDrivenIteratactiveTransition.attachToViewController(presentingViewController) // Master View Controller
            
            return self.percentDrivenIteratactiveTransition
            
        } else {
            
            self.percentDrivenIteratactiveTransition.attachToViewController(self.interactiveViewController) // Modal View Controller
            
            return nil
        }
        
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        return self.percentDrivenIteratactiveTransition.isDrivenInteractiveTransition() ? self.percentDrivenIteratactiveTransition : nil
    }
    
    // MARK: - Interactive animation class adjustmens
    
    var interactiveViewController: UIViewController! {
        didSet {
//            self.exitPanGesture = UIPanGestureRecognizer()
//            self.exitPanGesture.addTarget(self, action:"handleOffstagePan:")
//            self.menuViewController.view.addGestureRecognizer(self.exitPanGesture)
        }
    }
}