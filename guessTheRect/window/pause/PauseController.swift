//
//  PauseController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 16/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol PauseControllerDelegate {
    func gameResumed()
}

class PauseController: PauseWindowDelegate {
    
    var container: UIView
    var shadowView: UIView
    var window: PauseWindow!
    
    var delegate: PauseControllerDelegate?
    
    init(container: UIView) {
        self.container = container
        
        self.shadowView = UIView()
        self.shadowView.frame = self.container.frame;
        self.shadowView.backgroundColor = UIColor.blackColor()
        self.shadowView.alpha = 0.3
        
        
        self.container.addSubview(self.shadowView)
    }
    
    func showPause() {
        self.window = PauseWindow()
        window.frame.origin = CGPoint(x: self.container.frame.size.width/2 - window.frame.size.width/2, y: self.container.frame.size.height/2 - window.frame.size.height/2)
        window.delegate  = self
        self.container.addSubview(window)
    }
    
    func pauseWindowTouched() {
        UIView.animateWithDuration(0.5, animations: {
            self.shadowView.alpha = 0
            self.window.alpha = 0
            }, completion: { finished in
                self.shadowView.removeFromSuperview()
                self.window.removeFromSuperview()
                if let listener = self.delegate {
                    listener.gameResumed()
                }
        })
        
        //remove from container
    }
}
