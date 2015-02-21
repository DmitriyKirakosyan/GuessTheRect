//
//  Box.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 23/09/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit
import AVFoundation

class Box: UIView {
    let SIZE_ACCURACY: CGFloat = 6;
    
    let frontSquare = UIView()
    let backSquare = UIView()
    
    var opened:Bool = false
    var activated:Bool = false;
    
    let boxNumber: Int = 0
    
    convenience init(backColor: UIColor, size: CGFloat, boxNumber: Int)
    {
        self.init(frontColor: Colors.getSolidFrontColor(), backColor: backColor, size: size, boxNumber: boxNumber)
    }
    
    init(frontColor: UIColor, backColor:UIColor, size: CGFloat, boxNumber: Int) {
        super.init()
        
        self.boxNumber = boxNumber
        self.frame.size = CGSize(width: size, height: size)
        
        self.frontSquare.frame.size = CGSize(width: size, height: size)
        self.backSquare.frame.size = CGSize(width: size, height: size)
        
        self.frontSquare.backgroundColor = frontColor
        self.backSquare.backgroundColor = backColor
        
        
//        self.frontSquare.layer.cornerRadius = Settings.getCornerRadius(self.frontSquare.frame.size.width)
//        self.backSquare.layer.cornerRadius = Settings.getCornerRadius(self.backSquare.frame.size.width)
        
        self.addSubview(self.frontSquare)
        
        self.layer.cornerRadius = Settings.getCornerRadius(self.frontSquare.frame.size.width)
        self.layer.masksToBounds = true
        let singleFingerTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        
        //self.addGestureRecognizer(singleFingerTap)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawNumber(number: Int) {
        self.backSquare.addSubview(self.createNumberText(number))
    }

    
    func isEmpty() -> Bool {
        return self.backSquare.backgroundColor!.isEqual(UIColor.blackColor())
    }
    
    func activate() { self.activated = true; }
    func deactivate() { self.activated = false; }
    
    func open()
    {
        if (!opened) {
            self.animateSquare()
            SoundManager.sharedInstance.playFlip()
        }
    }
    
    func close()
    {
        if (opened) {
            self.animateSquare()
            SoundManager.sharedInstance.playBackFlip()
        }
    }
    
    func switchSide() {
        opened ? self.close() : self.open()
    }
    
    func handleTap(recognizer: UITapGestureRecognizer)
    {
        self.animateSquare()
    }
    
    
    
    func animateSquare() {
        self.animateSquare(nil, onComplete: nil)
    }
    func animateSquare(target: AnyObject?, onComplete: Selector)
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
        UIView.transitionFromView(views.frontView, toView: views.backView, duration: 0.4, options: transitionOptions,
            completion: { finished in
                if let targetObject: AnyObject = target {
                }
        })
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
    
    
    func createNumberText(number: Int) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: Settings.mainFont, size: Settings.getBoxNumberSize(self.frame.size))
        label.textColor = UIColor.whiteColor()
        
        //textLabel.frame.size = frameSize
        label.textAlignment = .Center
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.text = String(number)
        label.sizeToFit()
        
        label.frame.origin = CGPoint(x: self.frame.size.width/2 - label.frame.size.width/2,
            y: self.frame.size.height/2 - label.frame.size.height/2)
        return label;
    }

}