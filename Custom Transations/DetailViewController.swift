//
//  DetailViewController.swift
//  Custom Transations
//
//  Created by Victor Gabana on 23/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private var customTransitioningDelegate: VGTransitioningDelegate = VGTransitioningDelegate()
    private var viewHeightAndYPosition: CGFloat?
    private let completeAnimationBound: CGFloat = 0.3
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    // MARK: - Life cycle
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        // Set modal presentation style to Custom
        self.modalPresentationStyle = .Custom
        
        // Setting the transition delegate
        self.transitioningDelegate = self.customTransitioningDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding the dismissal gesture recognizer
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dismissalPanGesture:"))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get the view position
        self.viewHeightAndYPosition = self.view.frame.height + self.view.frame.origin.y
    }
    
    // MARK: - UIGestureRecognizer
    
    /**
    Inside of this method we call the UIPercentDrivenInteractiveTransition methods to reflect the current progress of the animation:
    cancelInteractiveTransition
    updateInteractiveTransition:
    finishInteractiveTransition
    */
    internal func dismissalPanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        if let viewHeightAndYPosition = self.viewHeightAndYPosition {
            let viewTranslation = gestureRecognizer.translationInView(gestureRecognizer.view?.superview)
            let percentCompleted = (-viewTranslation.y) / viewHeightAndYPosition
            
            // Tell the TrainsitioningDelegate that it is a interactive transition before updating the percentDrivenIteratactiveTransition
            self.customTransitioningDelegate.isDrivenInteractiveDismissalTransition = gestureRecognizer.state == .Began || gestureRecognizer.state == .Changed
            
            switch gestureRecognizer.state {
            case .Began:
                self.dismissViewControllerAnimated(true, completion: nil)
            case .Changed:
                self.customTransitioningDelegate.percentDrivenIteratactiveTransition.updateInteractiveTransition(percentCompleted)
            case .Cancelled, .Ended:
                if percentCompleted < self.completeAnimationBound || gestureRecognizer.state == .Cancelled {
                    self.customTransitioningDelegate.percentDrivenIteratactiveTransition.cancelInteractiveTransition()
                } else {
                    self.customTransitioningDelegate.percentDrivenIteratactiveTransition.finishInteractiveTransition()
                }
            default:
                print("gestureRecognizer state not handled")
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dismissAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

