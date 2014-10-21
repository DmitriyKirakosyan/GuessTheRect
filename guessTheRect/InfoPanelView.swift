//
//  InfoPanelView.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 15/10/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol InfoPanelProtocol {
    func gotToMenu()
    func restart()
    func maxScore() -> Int
}

class InfoPanelView: UIView {
    @IBOutlet weak var timerLabel: UILabel!
    var scoreLabel: UILabel!
    
    var delegate: InfoPanelProtocol?
    
    var timer: NSTimer?
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.createScoreLabel()
    }
    
    func createScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel.font = UIFont(name: Settings.mainFont, size: 24)
        scoreLabel.frame.origin = CGPoint(x: timerLabel.frame.size.width + timerLabel.frame.origin.x, y: timerLabel.frame.origin.y)
        scoreLabel.frame.size = CGSize(width: self.frame.size.width - scoreLabel.frame.origin.x, height: timerLabel.frame.size.height)
        scoreLabel.textAlignment = .Center
        scoreLabel.text = "100"
        self.addSubview(scoreLabel)
    }
    
    @IBAction func toMenu(sender: AnyObject) {
        if delegate != nil {
            delegate?.gotToMenu()
        }
    }
    
    @IBAction func restart(sender: AnyObject) {
        if delegate != nil {
            delegate?.restart()
        }
    }
    
    func clear() {
        self.stopTimer()
        timerLabel.text = "00:00"
        if (delegate != nil) {
            scoreLabel.text = String(delegate!.maxScore())
        } else {
            scoreLabel.text = "0"
        }
    }
    
    //NOTE This is an unstable solution
    func updateSize() {
        self.frame.size.height = 50
    }
    
    func startTimer() {
        if timer != nil { timer!.invalidate() }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("onTimer"), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
    }
    func isTimerRunning() -> Bool {
        return timer != nil
    }
    
    func getScore() -> Int {
        return scoreLabel.text!.toInt()!
    }
    
    func getTime() -> Int {
        let timeItems = NSString(string: timerLabel.text!).componentsSeparatedByString(":")
        let mins = (timeItems[0] as String).toInt()
        let secs = (timeItems[1] as String).toInt()
        return secs! + (60 * mins!)
    }
    
    func decreaseScore() {
        var scoreInt = scoreLabel.text!.toInt()
        if (scoreInt > 0) {
            scoreLabel.text = String(scoreInt! - 10)
        }
    }
    
    func onTimer() {
        self.increaseTimerSec()
    }
    
    func increaseTimerSec() {
        let labelStr = NSString(string: timerLabel.text!)
        let timeItems = labelStr.componentsSeparatedByString(":")
        var mins = (timeItems[0] as String).toInt()!
        var secs = (timeItems[1] as String).toInt()!
        if (secs != 59) {
            secs += 1
        } else if (mins != 59){
            mins += 1
            secs = 0
        }
        let minsStr = mins < 10 ? "0" + String(mins) : String(mins)
        let secsStr = secs < 10 ? "0" + String(secs) : String(secs)
        timerLabel.text = minsStr + ":" + secsStr
    }
}
