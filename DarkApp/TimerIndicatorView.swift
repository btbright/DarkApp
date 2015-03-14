//
//  TimerIndicatorView.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/12/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import UIKit

class TimerIndicatorView: UIView {
    let drainAnimationDuration: Double = 5.0
    let setupAnimationDuration: Double = 0.15
    var indicatorView: UIView? = nil
    var isAnimating: Bool = false
    var isActive: Bool = false
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        indicatorView = UIView(frame: CGRect(origin: CGPointMake(0.0, frame.size.height), size: CGSize(width: frame.size.width, height: 0)))
        indicatorView!.backgroundColor = UIColors.Chat.Random()
        addSubview(indicatorView!)
    }
    
    override func layoutSubviews() {
        if let subView = indicatorView as UIView! {
            if (!isAnimating && isActive){
                subView.frame = CGRect(origin: CGPointZero, size: frame.size)
            }
        }
    }
    
    func setupTimerAnimation(isSetup: Bool){
        if indicatorView == nil { return }
        isActive = true
        let unsetFrame = CGRect(origin: CGPointMake(0.0, frame.size.height), size: CGSize(width: frame.size.width, height: 0))
        let setFrame = CGRect(origin: CGPointZero, size: frame.size)
        if !isAnimating {
            indicatorView!.frame = isSetup ? unsetFrame : setFrame
        }
        self.indicatorView!.frame = isSetup ? setFrame : unsetFrame
        
        UIView.animateWithDuration (setupAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.AllowUserInteraction, animations: { [unowned self] in
            self.indicatorView!.frame = isSetup ? setFrame : unsetFrame
        }, completion: { [unowned self] (value: Bool) in
            self.isActive = true
        })
    }
    
    func startTimerAnimation(callback: () -> ()){
        isAnimating = true
        UIView.animateWithDuration (drainAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.AllowUserInteraction,animations: { [unowned self] in
            self.indicatorView!.frame = CGRect(origin: CGPointMake(0.0, self.frame.size.height), size: CGSize(width: self.frame.size.width, height: 0))
        }, completion: { [unowned self] (didFinish: Bool) in
                self.isAnimating = false
                self.isActive = false
                callback()
        })
    }
}
