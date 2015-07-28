//
//  VGPresentationController.swift
//  Custom Transations
//
//  Created by Victor Gabana on 23/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

class VGPresentationController: UIPresentationController {
    
    
    lazy var dimmingView: UIView = {
        let dimmingView = UIView(frame: self.containerView!.bounds)
        dimmingView.backgroundColor = UIColor.blackColor()

        return dimmingView
    }()
    
    
    override func presentationTransitionWillBegin()
    {
        // Add a custom dimming view behind the presented view controller's view
        self.containerView!.addSubview(self.dimmingView)
        self.dimmingView.addSubview(self.presentedViewController.view)
        
        self.dimmingView.alpha = 0
        
        // Use the transition coordinator to set up the animations, make sure our animation runs along side any other animations
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        {
            // Fade in the dimming view during the transition.
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 0.5
                }, completion:nil)
        }
    }
    
    override func presentationTransitionDidEnd(completed: Bool)
    {
        if !completed
        {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()
    {
        // Use the transition coordinator to set up the animations, make sure our animation runs along side any other animations
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        {
            transitionCoordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                self.dimmingView.alpha = 0
                }, completion: nil)
        }
    }
    
    override func dismissalTransitionDidEnd(completed: Bool)
    {
        if completed
        {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect
    {
        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = self.containerView!.bounds;
        frame = CGRectInset(frame, 50.0, 50.0)
        
        return frame
    }
    
    // MARK: - UIContentContainer Protocol
    /*
    The methods of the UIContentContainer protocol help you adapt the contents of your view controllers to size and trait changes. All UIViewController and UIPresentationController objects provide default implementations for the methods of this protocol. When creating your own custom view controller or presentation controller, you can override the default implementations to make adjustments to your content. For example, you might use these methods to adjust the size or position of any child view controllers.
    
    When overriding the methods of this protocol, you should generally call super to give UIKit a chance to perform any default behaviors. View controllers and presentation controllers perform their own adjustments when these methods are called. Calling super ensures that UIKit is able to continue making the changes it needs to adapt your interface to changes.
    */
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)
        
        transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.frame = self.containerView!.bounds
            },
            completion:nil)
    }
    
//    func willTransitionToTraitCollection(_ newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    
//    func sizeForChildContentContainer(_ container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize
    
//    func preferredContentSizeDidChangeForChildContentContainer(_ container: UIContentContainer)
    
//    func systemLayoutFittingSizeDidChangeForChildContentContainer(_ container: UIContentContainer)
    
//    var preferredContentSize: CGSize { get }
}
