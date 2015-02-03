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
    let LABEL_TIME = "time"
    let LABEL_SCORE = "score"
    let LABEL_BEST = "best"
    
    let TEXT_SIZE_DEVIDER: CGFloat = 10
    
    var sideOffset: CGFloat = 10;
    
    var timerLabel: UILabel!
    var scoreLabel: UILabel!
    var bestScoreLabel: UILabel!
    var pairsCounterLabel: UILabel!;
    
    var delegate: InfoPanelProtocol?
    
    init(frame: CGRect, sideOffset: CGFloat)
    {
        super.init(frame: frame)
        self.sideOffset = sideOffset
        self.createComponents()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    func setTime(time: Int) {
        timerLabel.text = self.timeToStr(time)
    }
    func setScore(score: Int) {
        scoreLabel.text = String(score)
    }
    func setPairsLeft(pairsLeft: Int) {
        pairsCounterLabel.text = "Matches left : " + String(pairsLeft)
    }

    func createComponents() {

        var label = self.addTitleLabel("TIME", index: 0);
        self.addSubview(label)
        label = self.addTitleLabel("SCORE", index: 1);
        self.addSubview(label)
        label = self.addTitleLabel("BEST", index: 2);
        self.addSubview(label)

        //valuable labels
        
        println("expect banner size : ")
        println(Settings.convertVirtualToRealByHeight(CGFloat(66)))
        
        
        self.timerLabel = self.addTitleLabel("00:00", index: 0, labelY: self.getTextSize())
        self.scoreLabel = self.addTitleLabel("100", index: 1, labelY: self.getTextSize())
        self.bestScoreLabel = self.addTitleLabel("0", index: 2, labelY: self.getTextSize())
        
        self.pairsCounterLabel = self.createBottomLabel("matches left : 0");
        
        self.bestScoreLabel.text = String(PlayerData.instance().getBestScore())
        
        self.addSubview(self.timerLabel)
        self.addSubview(self.scoreLabel)
        self.addSubview(self.bestScoreLabel)
        self.addSubview(self.pairsCounterLabel)
    }
    
    func addTitleLabel(text: String, index: Int) -> UILabel {
        return self.addTitleLabel(text, index: index, labelY: 0)
    }
    
    func addTitleLabel(text: String, index: Int, labelY: CGFloat) -> UILabel {
        var titleLabelWidth: CGFloat = (self.frame.size.width - (sideOffset * 2)) / 3
        
        var label: UILabel = self.createTitleLabel(text, frameWidth: titleLabelWidth)
        label.textAlignment = index == 0 ? .Left : index == 1 ? .Center : .Right
        label.frame.origin.x = sideOffset + titleLabelWidth * CGFloat(index)
        label.frame.origin.y = labelY
        return label
    }
    
    func createTitleLabel(text: String, frameWidth: CGFloat) -> UILabel {
        var result: UILabel = UILabel()
        let textSize = self.getTextSize()
        result.font = UIFont(name: Settings.mainFont, size: textSize)
        
        result.frame.size = CGSize(width: frameWidth, height: textSize)
        
        result.text = text;
        return result;
    }
    
    func createBottomLabel(text: String) -> UILabel {
        var result: UILabel = UILabel()
        let textSize = self.getTextSize()
        result.font = UIFont(name: Settings.mainFont, size: textSize)
        
        result.text = text;
        result.sizeToFit()
        
        result.frame.origin = CGPoint(x: self.frame.size.width/2 - result.frame.size.width/2, y: self.frame.size.height - result.frame.size.height)

        return result;
    }
    
    func getTextSize() -> CGFloat {
        return Settings.TEXT_SIZE
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
    
    
    //NOTE This is an unstable solution
    func updateSize() {
        self.frame.size.height = 50
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
    
    func timeToStr(time: Int) -> String {
        let mins: Int = time / 60
        let secs: Int = time % 60
        return self.timeToStr(mins, secs: secs)
    }
    func timeToStr(mins: Int, secs: Int) -> String {
        let minsStr = mins < 10 ? "0" + String(mins) : String(mins)
        let secsStr = secs < 10 ? "0" + String(secs) : String(secs)
        return minsStr + ":" + secsStr
    }
    
}
