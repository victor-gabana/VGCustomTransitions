//
//  VGPercentDrivenInteractiveTransition.swift
//  Custom Transations
//
//  Created by Victor Gabana on 30/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

/// Already implementes the UIViewControllerInteractiveTransitioning protocol
class VGPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var interactiveViewController: UIViewController!
    
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    var completionSeed: CGFloat {
        return 1 - percentComplete
    }
    
    let gestureRecognizer = UIPanGestureRecognizer()
    
    func attachToViewController(viewController: UIViewController) {
        self.interactiveViewController = viewController
        setupGestureRecognizer(viewController.view)
    }
    
    private func setupGestureRecognizer(view: UIView) {
        self.gestureRecognizer.addTarget(self, action: "handlePanGesture:")
        view.addGestureRecognizer(self.gestureRecognizer)
    }
    
    /**
    Inside of this function we call the UIPercentDrivenInteractiveTransition methods to reflect the current progress of the animation:
    cancelInteractiveTransition
    updateInteractiveTransition:
    finishInteractiveTransition
    */
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let viewTranslation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        switch gestureRecognizer.state {
        case .Began:
            self.transitionInProgress = true
            self.interactiveViewController.dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            let percentCompleted = -viewTranslation.y / 500
            print("y = \(viewTranslation.y)")
            print("percentCompleted \(percentCompleted)")
            
            self.shouldCompleteTransition = percentCompleted > 0.3
            updateInteractiveTransition(percentCompleted)
        case .Cancelled, .Ended:
            self.transitionInProgress = false
            if !self.shouldCompleteTransition || gestureRecognizer.state == .Cancelled {
                cancelInteractiveTransition()
            } else {
                finishInteractiveTransition()
            }
        default:
            print("Swift switch must be exhaustive, thus the default")
        }
    }
    
    func isDrivenInteractiveTransition() -> Bool {
        
        return self.gestureRecognizer.state == .Began || self.gestureRecognizer.state == .Changed
    }
    
}