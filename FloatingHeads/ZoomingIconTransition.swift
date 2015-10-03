//
//  ZoomingIconTransition.swift
//  ZoomingIconsMenu
//
//  Created by asu on 2015-10-01.
//  Copyright © 2015 asu. All rights reserved.
//

import UIKit


protocol ZoomingIconViewController {
    func zoomingIconBackgroundColourViewForTransition(transition: ZoomingIconTransition) -> UIView?
    func zoomingIconImageViewForTransition(transition: ZoomingIconTransition) -> UIImageView?
}

struct AnimationData {
    var transitionContext: UIViewControllerContextTransitioning?

    var duration: NSTimeInterval?
    var startViewController: UIViewController?
    var endViewController: UIViewController?
    var containerView: UIView?
    
    var startBackgroundView: UIView?
    var startIconView: UIView?
    
    var endBackgroundView: UIView?
    var endIconView: UIView?
    
    var snapshotOfStartBackgroundView: UIView?
    var snapshotOfStartIconView: UIView?
    
    var endViewBackgroundColour: UIColor?
    
    mutating func initForZoom(transition:ZoomingIconTransition, transitionContext:UIViewControllerContextTransitioning){
        self.transitionContext = transitionContext

        self.duration = transition.transitionDuration(transitionContext)
        self.startViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        self.endViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        self.containerView = transitionContext.containerView()!

        self.startBackgroundView = (startViewController as! ZoomingIconViewController).zoomingIconBackgroundColourViewForTransition(transition)!
        self.startIconView = (startViewController as! ZoomingIconViewController).zoomingIconImageViewForTransition(transition)!
        
        self.endBackgroundView = (endViewController as! ZoomingIconViewController).zoomingIconBackgroundColourViewForTransition(transition)!
        self.endIconView = (endViewController as! ZoomingIconViewController).zoomingIconImageViewForTransition(transition)!

    }
    

}

class ZoomingIconTransition: NSObject, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate{
    
    private let kZoomingIconTransitionDuration: NSTimeInterval = 2.0
    private let kZoomingIconTransitionZoomedScale: CGFloat = 15
    private let kZoomingIconTransitionBackgroundScale: CGFloat = 0.80
    
    var operation: UINavigationControllerOperation = .None
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        
        return kZoomingIconTransitionDuration
        
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        if operation == .Push {
            
            executeZoomTransition(transitionContext)
            
        } else if operation == .Pop {
            
            executeUnzoomTransition(transitionContext)
            
        }
    }
    
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            if fromVC is ZoomingIconViewController &&
                toVC is ZoomingIconViewController {
                    
                    self.operation = operation
                    
                    return self
            }
            return nil
    }
    
    
    
    // MARK: private
    
    private func executeZoomTransition(transitionContext: UIViewControllerContextTransitioning){
        
        var animationData = AnimationData()
        animationData.initForZoom(self, transitionContext: transitionContext)
        
        // create view snapshots
        // view controller need to be in view hierarchy for snapshotting
        animationData.containerView!.addSubview(animationData.startViewController!.view)
        animationData.snapshotOfStartBackgroundView = animationData.startBackgroundView!.snapshotViewAfterScreenUpdates(false)
        animationData.snapshotOfStartIconView = animationData.startIconView!.snapshotViewAfterScreenUpdates(false)
        animationData.snapshotOfStartIconView!.contentMode = .ScaleAspectFill
        
        animationData.endViewBackgroundColour = animationData.endViewController!.view.backgroundColor!
        
        // setup animation
        prepareForAnimation(animationData)

        // Pre-Animation states
        animationData.startViewController!.view.transform = CGAffineTransformIdentity
        animationData.startViewController!.view.alpha = 1
        animationData.snapshotOfStartBackgroundView!.transform = CGAffineTransformIdentity
        animationData.snapshotOfStartBackgroundView!.frame =
            animationData.containerView!.convertRect(
                animationData.startBackgroundView!.frame,
                fromView:animationData.startBackgroundView!.superview)
        animationData.snapshotOfStartIconView!.frame =
            animationData.containerView!.convertRect(
                animationData.startIconView!.frame,
                fromView:animationData.startIconView!.superview)
        
        // Need to layout now if we want the correct parameters for frame
        animationData.endViewController!.view.layoutIfNeeded()
        
        // perform animation
        UIView.animateWithDuration(animationData.duration!, delay: 0, usingSpringWithDamping: 1,
            initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                
                // Post-Animation states
                animationData.startViewController!.view.transform =
                    CGAffineTransformMakeScale(self.kZoomingIconTransitionBackgroundScale, self.kZoomingIconTransitionBackgroundScale)
                animationData.startViewController!.view.alpha = 0
                
                animationData.snapshotOfStartBackgroundView!.transform =
                    CGAffineTransformMakeScale(self.kZoomingIconTransitionZoomedScale, self.kZoomingIconTransitionZoomedScale)
                animationData.snapshotOfStartBackgroundView!.center =
                    animationData.containerView!.convertPoint(
                        animationData.endBackgroundView!.center,
                        fromView:animationData.endBackgroundView!.superview)
                
                animationData.snapshotOfStartIconView!.frame =
                    animationData.containerView!.convertRect(
                        animationData.endIconView!.frame,
                        fromView:animationData.endIconView!.superview!)
                
            },
            completion: { (finished) in
                
                self.cleanupAfterAnimation(animationData)
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                
        })
        
        
    }
    
    private func executeUnzoomTransition(transitionContext: UIViewControllerContextTransitioning){
        
        let duration = transitionDuration(transitionContext)
        let startViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let endViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        let startBackgroundView = (startViewController as! ZoomingIconViewController).zoomingIconBackgroundColourViewForTransition(self)!
        let startIconView = (startViewController as! ZoomingIconViewController).zoomingIconImageViewForTransition(self)!
        
        let endBackgroundView = (endViewController as! ZoomingIconViewController).zoomingIconBackgroundColourViewForTransition(self)!
        let endIconView = (endViewController as! ZoomingIconViewController).zoomingIconImageViewForTransition(self)!
        
        // create view snapshots
        // view controller need to be in view hierarchy for snapshotting
        containerView.addSubview(endViewController.view)
        let snapshotOfEndBackgroundView = endBackgroundView.snapshotViewAfterScreenUpdates(false)
        let snapshotOfEndIconView = UIImageView(image: endIconView.image)
        snapshotOfEndIconView.contentMode = .ScaleAspectFit
        
        let startViewBackgroundColour = startViewController.view.backgroundColor!
        
        // setup animation
        prepareForAnimationUnzoom(containerView,
            startViewController: startViewController, endViewController: endViewController,
            snapshotOfEndBackgroundView: snapshotOfEndBackgroundView, snapshotOfEndIconView: snapshotOfEndIconView,
            startBackgroundView: startBackgroundView, startIconView: startIconView,
            endBackgroundView: endBackgroundView, endIconView: endIconView)
        
        
        // Pre-Animation states
        endViewController.view.transform =
            CGAffineTransformMakeScale(self.kZoomingIconTransitionBackgroundScale, self.kZoomingIconTransitionBackgroundScale)
        endViewController.view.alpha = 0
        
        snapshotOfEndBackgroundView.transform =
            CGAffineTransformMakeScale(self.kZoomingIconTransitionZoomedScale, self.kZoomingIconTransitionZoomedScale)
        snapshotOfEndBackgroundView.center = containerView.convertPoint(startIconView.center, fromView: startIconView.superview)
        
        let convertedFrame = containerView.convertRect(startIconView.frame, fromView: startIconView.superview!)
        snapshotOfEndIconView.frame = convertedFrame
        
        // Need to layout now if we want the correct parameters for frame
        startViewController.view.layoutIfNeeded()
        
        // perform animation
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1,
            initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                
                // Post-Animation states
                endViewController.view.transform = CGAffineTransformIdentity
                endViewController.view.alpha = 1
                
                snapshotOfEndBackgroundView.transform = CGAffineTransformIdentity
                snapshotOfEndBackgroundView.center = containerView.convertPoint(endIconView.center, fromView: endIconView.superview)
                
                let convertedFrame = containerView.convertRect(endIconView.frame, fromView: endIconView.superview!)
                snapshotOfEndIconView.frame = convertedFrame

                
            },
            completion: { (finished) in
                
                self.cleanupAfterAnimationUnzoom(startViewController, endViewController: endViewController,
                    endViewBackgroundColour: startViewBackgroundColour,
                    snapshotOfEndBackgroundView: snapshotOfEndBackgroundView, snapshotOfEndIconView: snapshotOfEndIconView,
                    startBackgroundView: startBackgroundView, startIconView: startIconView,
                    endBackgroundView: endBackgroundView, endIconView: endIconView)
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                
        })
    }
    
    private func prepareForAnimation(animationData:AnimationData){
        
            animationData.startBackgroundView!.hidden = true
            animationData.endBackgroundView!.hidden = true
            
            animationData.startIconView!.hidden = true
            animationData.endIconView!.hidden = true
            
            animationData.endViewController!.view.backgroundColor = UIColor.clearColor()
            
            animationData.containerView!.backgroundColor = UIColor.whiteColor()
            animationData.containerView!.addSubview(animationData.startViewController!.view)
            animationData.containerView!.addSubview(animationData.snapshotOfStartBackgroundView!)
            animationData.containerView!.addSubview(animationData.endViewController!.view)
            animationData.containerView!.addSubview(animationData.snapshotOfStartIconView!)

    }
    
    private func cleanupAfterAnimation(animationData:AnimationData){
    
            animationData.startViewController!.view.transform = CGAffineTransformIdentity
            
            animationData.snapshotOfStartBackgroundView!.removeFromSuperview()
            animationData.snapshotOfStartIconView!.removeFromSuperview()
            
            animationData.startBackgroundView!.hidden = false
            animationData.endBackgroundView!.hidden = false
            
            animationData.startIconView!.hidden = false
            animationData.endIconView!.hidden = false
            
            animationData.endViewController!.view.backgroundColor = animationData.endViewBackgroundColour!
   
    }
    
    
    private func prepareForAnimationUnzoom(animationContainerView:UIView,
        startViewController: UIViewController, endViewController: UIViewController,
        snapshotOfEndBackgroundView:UIView, snapshotOfEndIconView:UIView,
        startBackgroundView:UIView, startIconView:UIView,
        endBackgroundView:UIView, endIconView:UIView){
            
            startBackgroundView.hidden = true
            endBackgroundView.hidden = true
            
            startIconView.hidden = true
            endIconView.hidden = true
            
            startViewController.view.backgroundColor = UIColor.clearColor()
            
            animationContainerView.backgroundColor = UIColor.whiteColor()
            animationContainerView.addSubview(endViewController.view)
            animationContainerView.addSubview(snapshotOfEndBackgroundView)
            animationContainerView.addSubview(startViewController.view)
            animationContainerView.addSubview(snapshotOfEndIconView)
            
    }
    
    private func cleanupAfterAnimationUnzoom(
        startViewController: UIViewController, endViewController: UIViewController,
        endViewBackgroundColour:UIColor,
        snapshotOfEndBackgroundView:UIView, snapshotOfEndIconView:UIView,
        startBackgroundView:UIView, startIconView:UIView,
        endBackgroundView:UIView, endIconView:UIView){
            
            endViewController.view.transform = CGAffineTransformIdentity
            
            snapshotOfEndBackgroundView.removeFromSuperview()
            snapshotOfEndIconView.removeFromSuperview()
            
            startBackgroundView.hidden = false
            endBackgroundView.hidden = false
            
            startIconView.hidden = false
            endIconView.hidden = false
            
            endViewController.view.backgroundColor = endViewBackgroundColour
            
    }

    
}
