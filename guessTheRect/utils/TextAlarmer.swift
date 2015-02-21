//
//  TextAlarmer.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 20/02/2015.
//  Copyright (c) 2015 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class TextAlarmer: NSObject
{
    var label: UILabel!
    
    var timer: NSTimer!
    
    var started: Bool = false
    
    var originColor: UIColor!
    
    init(label: UILabel) {
        super.init()
        self.label = label
        self.originColor = self.label.textColor
    }
    
    
    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(self.timerDuration(), target: self, selector: Selector("onTimer"), userInfo: nil, repeats: true)
        started = true
    }
    
    func stop() {
        timer.invalidate()
        timer = nil
        started = false
        label.textColor = originColor
    }
    
    func timerDuration() -> NSTimeInterval {
        return 0.5
    }
    
    func onTimer() {
        if self.label.textColor == originColor {
            label.textColor = UIColor.redColor()
        } else {
            label.textColor = originColor
        }
    }
    
}
