//
//  ScoreManager.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 1/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol ScoreManagerDelegate {
    func levelCompleted()
    func gameOver()
}

class ScoreManager: NSObject {
    
    var levelVO: LevelVO!
    var infoPanel: InfoPanelView!
    
    var pairsCompleted: Int = 0
    var score: Int = 0
    var currentTime: Int = 0
    
    var timer: NSTimer?
    
    var delegate: ScoreManagerDelegate?
    
    init(infoPanel: InfoPanelView) {
        super.init()
        self.infoPanel = infoPanel
        self.updateInfoPanel()
    }
    
    func setLevel(levelVO: LevelVO) {
        self.levelVO = levelVO
        pairsCompleted = 0
        currentTime = self.levelVO.time
        self.updateInfoPanel()
    }
    
    func pause() {
        self.stopTimer()
    }
    
    func resume() {
        self.startTimer()
    }
   
    func gameDidStart() {
        if levelVO == nil {
            println("ERROR! scoreManager can't start without levelVO")
            return
        }
        self.startTimer()
    }
    
    func gameDidRestart() {
        self.stopTimer()
        self.score = 0
    }
    
    func pairDidComplete() {
        pairsCompleted++
        score += levelVO.pairPoints
        self.currentTime += 10
        self.updateInfoPanel()
        
        if pairsCompleted >= levelVO.pairs {
            self.delegate?.levelCompleted()
        }
    }
    
    func pairDidClose() {
        score -= levelVO.minusPoints
        if score < 0 { score = 0 }
        self.updateInfoPanel()
    }
    
    //private methods
    
    func updateInfoPanel() {
        self.infoPanel.setTime(currentTime)
        self.infoPanel.setScore(self.score)
        if (levelVO != nil) {
            self.infoPanel.setPairsLeft(self.levelVO.pairs - self.pairsCompleted)
        }
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

    func onTimer() {
        if currentTime > 0 { currentTime-- }
        self.updateInfoPanel()
        if currentTime == 0 {
            self.stopTimer()
            self.delegate?.gameOver()
        }
    }

}
