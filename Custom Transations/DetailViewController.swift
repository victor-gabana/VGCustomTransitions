//
//  DetailViewController.swift
//  Custom Transations
//
//  Created by Victor Gabana on 23/07/2015.
//  Copyright © 2015 Victor Gabana. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private var customTransitioningDelegate: VGTransitioningDelegate?
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        // Set modal presentation style to Custom
        self.modalPresentationStyle = .Custom
        
        // Stting the transition delegate
        self.customTransitioningDelegate = VGTransitioningDelegate()
        self.transitioningDelegate = self.customTransitioningDelegate
    }


    @IBAction func dismissAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

