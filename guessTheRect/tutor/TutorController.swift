//
//  TutorController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 3/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol TutorControllerDelegate {
    func tutorFinished()
}

class TutorController: TutorDelegate {
    
    let steps = [TutorStep.FindTheSame, TutorStep.AboutTime, TutorStep.ClosingWarning]
    var currentStepIndex = 0
    var container: UIView!
    
    var flipSquare: UIView!
    var shadowBack: UIView!
    
    var tutorWindow: TutorWindow?
    
    var delegate: TutorControllerDelegate?
    
    init(container: UIView) {
        self.container = container
        tutorWindow = nil

        self.flipSquare = UIView()
        self.flipSquare.frame = self.container.frame
        
        
        //blur magic
        UIGraphicsBeginImageContextWithOptions(self.container.bounds.size, true, 0)
        self.container.layer.renderInContext(UIGraphicsGetCurrentContext())
        println(self.container.bounds)
        var imgaa :UIImage = UIGraphicsGetImageFromCurrentImageContext();
        var ciimage :CIImage = CIImage(image: imgaa)
        var filter : CIFilter = CIFilter(name:"CIGaussianBlur")
        filter.setDefaults()

        filter.setValue(ciimage, forKey: kCIInputImageKey)
        filter.setValue(5, forKey: kCIInputRadiusKey)

        var outputImage : CIImage = filter.outputImage;
        var finalImage = UIImage(CIImage: outputImage)
        
        self.shadowBack = UIImageView(image: finalImage)
        self.shadowBack.frame.origin = CGPoint(x: self.container.frame.size.width/2 - self.shadowBack.frame.size.width/2, y: self.container.frame.size.height/2 - self.shadowBack.frame.size.height/2)
        println(self.shadowBack.frame)
        
        self.container.addSubview(self.shadowBack)

        self.container.addSubview(self.flipSquare)
    }
    
    func startTutorial()
    {
        self.showNextTutorWindow()
    }
    
    func showNextTutorWindow() {
        if currentStepIndex < steps.count {
            let oldTutorWindow = self.tutorWindow
            tutorWindow = TutorWindow(step: steps[currentStepIndex])
            
            tutorWindow!.frame.origin = CGPoint(x: container.frame.size.width/2 - tutorWindow!.frame.size.width/2, y: container.frame.size.height/2 - tutorWindow!.frame.size.height/2)
            
            tutorWindow!.delegate = self
            
            if (oldTutorWindow != nil) {
                let views = (frontView: oldTutorWindow!, backView: self.tutorWindow!)
                UIView.transitionFromView(views.frontView, toView: views.backView, duration: 0.4, options: .TransitionFlipFromRight, completion: nil)
                
            } else {
                self.flipSquare.addSubview(tutorWindow!)
            }
            currentStepIndex++
        }
        else {
            if let flip = flipSquare {
                flip.removeFromSuperview()
            }
            if let back = shadowBack {
                back.removeFromSuperview()
            }
            
            if let ensureDelegate = delegate {
                ensureDelegate.tutorFinished()
            }
        }
    }
    
    func tutorTouched() {
        self.showNextTutorWindow()
    }
}
