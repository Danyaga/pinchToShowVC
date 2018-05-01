//
//  ViewController.swift
//  pinchToShowVC
//
//  Created by Daniel Sonny Agliardi on 01/05/2018.
//  Copyright © 2018 DSA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var interactiveTransition: UIPercentDrivenInteractiveTransition!
    
    var isPresenting: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(onPinch(sender:))))

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self
        
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController!,
                                                   presentingController presenting: UIViewController!,
                                                   sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        print("animating transition")
        var containerView = transitionContext.containerView
        var toViewController = transitionContext.viewController(forKey: .to)!
        var fromViewController = transitionContext.viewController(forKey: .from)!
        
        if (isPresenting) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           animations: { () -> Void in
                toViewController.view.alpha = 1
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
            }
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           animations: { () -> Void in
                fromViewController.view.alpha = 0
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
                fromViewController.view.removeFromSuperview()
            }
        }
    }
    

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        interactiveTransition = UIPercentDrivenInteractiveTransition()
        //Setting the completion speed gets rid of a weird bounce effect bug when transitions complete
//        interactiveTransition.completionSpeed = 0.99
        return interactiveTransition
        
    }
    
    @objc func onPinch(sender: UIPinchGestureRecognizer) {
        var scale = sender.scale
        var velocity = sender.velocity
        if (sender.state == UIGestureRecognizerState.began){
            //blueSegue is the name we gave our modal segue, this also starts our interactive transition
            performSegue(withIdentifier: "blueSegue", sender: self)
        } else if (sender.state == UIGestureRecognizerState.changed){
            //We are dividing by 7 here since updateInteractiveTransition expects a number between 0 and 1
            interactiveTransition.update(scale / 7)
        } else if sender.state == UIGestureRecognizerState.ended {
            if velocity > 0 {
                interactiveTransition.finish()
            } else {
                interactiveTransition.cancel()
            }
        }
    }
    
}


public class SecondViewController : UIViewController {
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
