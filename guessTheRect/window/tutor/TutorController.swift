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
    
    let steps = [TutorStep.FindTheSame, TutorStep.AboutTime]
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
        
        self.shadowBack = Utils.createBlurScreen(self.container)
        
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
                UIView.transitionFromView(oldTutorWindow!, toView: self.tutorWindow!, duration: 0.4, options: .TransitionFlipFromRight, completion: nil)
                
            } else {
                self.flipSquare.addSubview(tutorWindow!)
            }
            currentStepIndex++
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                if let flip = self.flipSquare {
                    flip.alpha = 0
                }
                if let back = self.shadowBack {
                    back.alpha = 0
                }
            }, completion: { finished in
                if let flip = self.flipSquare {
                    flip.removeFromSuperview()
                }
                if let back = self.shadowBack {
                    back.removeFromSuperview()
                }
            })
            
            if let ensureDelegate = delegate {
                ensureDelegate.tutorFinished()
                delegate = nil
            }
        }
    }
    
    func tutorTouched() {
        self.showNextTutorWindow()
    }
}
