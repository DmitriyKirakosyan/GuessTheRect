//
//  InfoWindowController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 1/02/2015.
//  Copyright (c) 2015 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol InfoWindowControllerDelegate {
    func infoWindowClosed()
}

class InfoWindowController: InfoWindowDelegate {
    
    var container: UIView
    var shadowView: UIView
    var window: InfoWindow!
    
    var delegate: InfoWindowControllerDelegate?
    
    var message: String
    
    init(container: UIView, message: String) {
        self.container = container
        
        self.shadowView = Utils.createBlurScreen(container)
        
        self.message = message
        
        self.container.addSubview(self.shadowView)
    }
    
    func showInfoView() {
        self.window = InfoWindow(message: self.message)
        window.frame.origin = CGPoint(x: self.container.frame.size.width/2 - window.frame.size.width/2, y: self.container.frame.size.height/2 - window.frame.size.height/2)
        window.delegate  = self
        self.container.addSubview(window)
    }
    
    func windowTouched() {
        UIView.animateWithDuration(1.5, animations: {
            self.shadowView.alpha = 0
            self.window.alpha = 0
            }, completion: { finished in
                self.shadowView.removeFromSuperview()
                self.window.removeFromSuperview()
                if let listener = self.delegate {
                    listener.infoWindowClosed()
                }
        })
        
        //remove from container
    }
}