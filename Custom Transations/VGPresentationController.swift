//
//  VGPresentationController.swift
//  Custom Transations
//
//  Created by Victor Gabana on 23/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

class VGPresentationController: UIPresentationController {
    
    private let presentedViewFrameInset: CGFloat = 50
    private let dimmingViewAlpha: CGFloat = 0.5
    private lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        if let containerView = self.containerView {
            dimmingView.frame = containerView.bounds
        }
        dimmingView.backgroundColor = UIColor.blackColor()
        
        return dimmingView
        }()
    
    // MARK: - Overrinding UIPresentationController methods
    
    /// Add custom views to the view hierarchy and to create any animations associated with those views.
    /// To ensure that your animations are executed at the same time as other transition animations, call animateAlongsideTransition:completion: or animateAlongsideTransitionInView:animation:completion: of the transition coordinator of the presented view controller.
    override func presentationTransitionWillBegin() {
        
        // Set the dimmingView alpha to 0 for the beginning of the animation
        self.dimmingView.alpha = 0
        
        // Use the transition coordinator to set up the animations, make sure our animation runs along side any other animations. Here we fade in the dimming view during the transition.
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({(UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView.alpha = self.dimmingViewAlpha
            }, completion:nil)

        // Add the presented view controller's view to the dimmingView
        self.dimmingView.addSubview(self.presentedViewController.view)
        
        // Add the dimingView with the presented view to the containerView
        self.containerView?.addSubview(self.dimmingView)
    }
    
    /// Perform any required cleanup
    override func presentationTransitionDidEnd(completed: Bool) {
        
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    /// Configure any animations associated with your presentation’s custom views.
    /// To ensure that your animations are executed at the same time as other transition animations, call animateAlongsideTransition:completion: or animateAlongsideTransitionInView:animation:completion: of the transition coordinator of the presented view controller.
    override func dismissalTransitionWillBegin() {
        
        // Use the transition coordinator to set up the animations, make sure our animation runs along side any other animations
        self.presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView.alpha = 0
            }, completion: nil)
    }
    
    /// Only if the completed parameter is true remove any custom views that the presentation controller added to the view hierarchy.
    override func dismissalTransitionDidEnd(completed: Bool) {
        
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    /// Returns the frame rectangle to assign to the presented view at the end of the animations.
    /// This method is called multiple times during the course of a presentation, so your return always the same frame.
    override func frameOfPresentedViewInContainerView() -> CGRect {
        
        if let containerView = self.containerView {
            // Inset the presented view frame so it wont be full screen
            return CGRectInset(containerView.bounds, self.presentedViewFrameInset, self.presentedViewFrameInset)
        } else {
            return CGRectZero
        }
    }
    
    // MARK: - UIContentContainer Protocol
    /*
    The methods of the UIContentContainer protocol help you adapt the contents of your view controllers to size and trait changes. All UIViewController and UIPresentationController objects provide default implementations for the methods of this protocol. When creating your own custom view controller or presentation controller, you can override the default implementations to make adjustments to your content. For example, you might use these methods to adjust the size or position of any child view controllers.
    
    When overriding the methods of this protocol, you should generally call super to give UIKit a chance to perform any default behaviors. View controllers and presentation controllers perform their own adjustments when these methods are called. Calling super ensures that UIKit is able to continue making the changes it needs to adapt your interface to changes.
    */
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)
        
        transitionCoordinator.animateAlongsideTransition({(UIViewControllerTransitionCoordinatorContext) -> Void in
            if let containerView = self.containerView {
                self.dimmingView.frame = containerView.bounds
            }
            },
            completion:nil)
    }
    
//    func willTransitionToTraitCollection(_ newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    
//    func sizeForChildContentContainer(_ container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize
    
//    func preferredContentSizeDidChangeForChildContentContainer(_ container: UIContentContainer)
    
//    func systemLayoutFittingSizeDidChangeForChildContentContainer(_ container: UIContentContainer)
    
//    var preferredContentSize: CGSize { get }
}
