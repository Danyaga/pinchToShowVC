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

        return self
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {

        return self
    }
    
    

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        print("animating transition")
        var containerView = transitionContext.containerView
        var toViewController = transitionContext.viewController(forKey: .to)!
        var fromViewController = transitionContext.viewController(forKey: .from)!
        
        toViewController.view.frame.origin.x = toViewController.view.frame.width
        
        containerView.addSubview(toViewController.view)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { () -> Void in
                        toViewController.view.frame.origin.x = 0
        }) { (finished: Bool) -> Void in
            if transitionContext.transitionWasCancelled {
                toViewController.dismiss(animated: false, completion: nil)
            }
            
            transitionContext.completeTransition(true)
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
            
            let secondViewController = SecondViewController()

            secondViewController.modalPresentationStyle = .custom
            secondViewController.transitioningDelegate = self

            self.present(secondViewController,
                         animated: true,
                         completion: nil)
            
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
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .blue
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
