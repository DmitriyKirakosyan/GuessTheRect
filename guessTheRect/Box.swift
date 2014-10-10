//
//  Box.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 23/09/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class Box: UIView {
    let frontSquare = UIView()
    let backSquare = UIView()
    
    var opened:Bool = false
    var activated:Bool = false;
    
    convenience init(backColor: UIColor, size: CGFloat)
    {
        self.init(frontColor: UIColor.greenColor(), backColor: backColor, size: size)
    }
    
    init(frontColor: UIColor, backColor:UIColor, size: CGFloat) {
        super.init()
        self.frame.size = CGSize(width: size, height: size)
        
        self.frontSquare.frame.size = CGSize(width: size, height: size)
        self.backSquare.frame.size = CGSize(width: size-4, height: size-4)
        self.backSquare.frame.origin = CGPoint(x: CGFloat(2), y: CGFloat(2))
        self.frontSquare.backgroundColor = frontColor
        self.backSquare.backgroundColor = backColor
        
        self.addSubview(self.frontSquare)
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        //self.addGestureRecognizer(singleFingerTap)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate() { self.activated = true; }
    func deactivate() { self.activated = false; }
    
    func open()
    {
        if (!opened) { self.animateSquare() }
    }
    
    func close()
    {
        if (opened) { self.animateSquare() }
    }
    
    func switchSide() {
        opened ? self.close() : self.open()
    }
    
    func handleTap(recognizer: UITapGestureRecognizer)
    {
        self.animateSquare()
    }
    
    func animateSquare()
    {
        var views = (frontView: UIView(), backView: UIView())
        if((self.frontSquare.superview) != nil){
            views = (frontView: self.frontSquare, backView: self.backSquare)
            opened = true;
        }
        else {
            views = (frontView: self.backSquare, backView: self.frontSquare)
            opened = false;
        }
        
        // set a transition style
        let transitionOptions = getFlipType()
        
        // with no animatiUIon block, and a completion block set to 'nil' this makes a single line of code
        UIView.transitionFromView(views.frontView, toView: views.backView, duration: 0.4, options: transitionOptions, completion: nil)
    }
    
    func getFlipType() -> UIViewAnimationOptions
    {
        switch random() % 4 {
        case 0: return UIViewAnimationOptions.TransitionFlipFromBottom
        case 1: return UIViewAnimationOptions.TransitionFlipFromTop
        case 2: return UIViewAnimationOptions.TransitionFlipFromLeft
        default: return UIViewAnimationOptions.TransitionFlipFromRight
        }
    }

}