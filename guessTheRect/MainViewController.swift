//
//  MainViewController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 29/09/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let MAX_ANIMATION_TIME: CGFloat = 1.5
    let difficulties = ["easy", "hard", "medium", "impossible"]
    
    let widthBtnsOffset:CGFloat = 15
    let topBtnsOffset:CGFloat = 100
    let containerOffset: CGFloat = 10
    
    var btns: [UIButton] = []
    var difficulty:Int = 0
    var animationTimer:NSTimer?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.getBackColor()
        self.createBtns()
        
        println("score for level 1 : \(PlayerData.instance().getLevelScore(1))")
        println("time for level 1 : \(PlayerData.instance().getLevelPassTime(1))")
        
    }
    
    func createBtns() {
        let smallSubOffset:CGFloat = 0//2
        let normalSubOffset: CGFloat = 0//5
        
        self.createContainer()
        
        btns.append(self.createMenuBtn(false, items: 3, offset: normalSubOffset))
        btns[0].frame.origin = CGPoint(x: widthBtnsOffset, y: topBtnsOffset)
        btns.append(self.createMenuBtn(false, items: 5, offset: smallSubOffset))
        btns[1].frame.origin = CGPoint(x: view.frame.size.width - widthBtnsOffset - btns[0].frame.size.width, y: topBtnsOffset)
        btns.append(self.createMenuBtn(true, items: 3, offset: normalSubOffset))
        btns[2].frame.origin = CGPoint(x: widthBtnsOffset, y: topBtnsOffset + btns[0].frame.size.height + widthBtnsOffset)
        btns.append(self.createMenuBtn(true, items: 5, offset: smallSubOffset))
        btns[3].frame.origin = CGPoint(x: view.frame.size.width - widthBtnsOffset - btns[0].frame.size.width, y: topBtnsOffset + btns[0].frame.size.height + widthBtnsOffset)
        
        
        for btn in btns {
            self.createBtnBests(btn)
            self.drawBtnDifficulty(btn)
            self.view.addSubview(btn)
        }

        self.runAnimationTimer()
    }
    
    func createContainer() {
        let containerSize: CGFloat = self.view.frame.size.width - ((widthBtnsOffset - containerOffset) * 2.0)
        println("container size : \(containerSize)")
        let containerX: CGFloat = widthBtnsOffset - containerOffset
        let containerY: CGFloat = topBtnsOffset - containerOffset
        var container = UIView()
        container.frame.origin = CGPoint(x: containerX, y: containerY)
        container.frame.size = CGSize(width: containerSize, height: containerSize)
        container.backgroundColor = Colors.getBackColor()
        //self.view.addSubview(container)
    }
    
    func runAnimationTimer() {
        self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(self.getAnimateTimerInterval(), target: self, selector:  Selector("scheduleAnimation"), userInfo: nil, repeats: false)
    }
    func stopAnimationTimer() {
        self.animationTimer!.invalidate()
    }
    
    func getAnimateTimerInterval() -> NSTimeInterval {
        return NSTimeInterval(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * MAX_ANIMATION_TIME)
    }
    
    func scheduleAnimation() {
        let btnIndex = random() % 2
        let btn = btns[btnIndex + 2]
        
        var boxIndex = 0
        do {
            boxIndex = random() % btn.subviews.count
        } while (!(btn.subviews[boxIndex] is Box))
        let box = btn.subviews[boxIndex] as Box
        box.switchSide()
        
        self.runAnimationTimer()
    }
    
    func onBtnDown(sender: AnyObject) {
        let btn: UIButton = sender as UIButton
        let index = find(btns, btn)
        if let btnIndex = index {
            self.stopAnimationTimer()
            difficulty = btnIndex
            self.performSegueWithIdentifier("startGame", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameController = segue.destinationViewController as ViewController
        gameController.difficulty = difficulty
    }
    
    
    func createMenuBtn(multiColor: Bool, items: Int, offset: CGFloat) -> UIButton {
        let btnSize:CGFloat = (self.view.frame.size.width - (self.widthBtnsOffset*3)) / 2
        var btn = UIButton()
        btn.frame.size = CGSize(width: btnSize, height: btnSize)
        btn.backgroundColor = self.getBtnColor()
        
        for var i = 0; i < items; ++i {
            for var j = 0; j < items; ++j {
                let subWidth:CGFloat = (btn.frame.size.width-offset) / CGFloat(items) - offset
                let subHeight:CGFloat = (btn.frame.size.height-offset) / CGFloat(items) - offset

                var frontColor = multiColor ? self.getRndColor() : UIColor.whiteColor()
                var subView = Box(frontColor: frontColor, backColor: self.getRndColor(), size: subWidth, boxNumber: 0)
                let subX: CGFloat = offset + CGFloat(i) * (subWidth+offset)
                let subY: CGFloat = offset + CGFloat(j) * (subHeight+offset)
                subView.frame.origin = CGPoint(x: subX, y: subY)
                subView.frame.size = CGSize(width: subWidth, height: subHeight)
                subView.userInteractionEnabled = false
                //subView.alpha = 0.25
                btn.addSubview(subView)
            }
        }
        
        let labelText = items == 5 ? "5x5" : "3x3"
        btn.addSubview(self.createBtnLabel(labelText, size: btn.frame.size))
        
        btn.addTarget(self, action: "onBtnDown:", forControlEvents: UIControlEvents.TouchDown)
        
        return btn
    }
    
    func drawBtnDifficulty(btn: UIButton) {
        let index: Int = find(btns, btn)!
        var diffLabel = createBtnScoreLabel(difficulties[index], btnSize: btn.frame.size)
        diffLabel.frame.origin.y = btn.frame.size.height - diffLabel.frame.size.height - 10
        btn.addSubview(diffLabel)
    }
    
    func createBtnBests(btn: UIButton) {
        let index: Int = find(btns, btn)!
        let bestTime = PlayerData.instance().getLevelPassTime(index+1)
        let bestScore = PlayerData.instance().getLevelScore(index+1)
        
        if bestTime > 0 {
            let topOffset = btn.frame.height/15
            var timeLabel = createBtnScoreLabel("best time : " + String(bestTime), btnSize: btn.frame.size)
            timeLabel.frame.origin.y = topOffset
            btn.addSubview(timeLabel)

            var scoreLabel = createBtnScoreLabel("best score : " + String(bestScore), btnSize: btn.frame.size)
            scoreLabel.frame.origin.y = topOffset + 2 + timeLabel.frame.size.height
            btn.addSubview(scoreLabel)
        }
    }
    
    func createBtnScoreLabel(text: String, btnSize: CGSize) -> UILabel {
        var result = UILabel()
        let fontSize = btnSize.width/12
        
        let font: UIFont = UIFont(name: Settings.mainFont, size: fontSize)!
        let dict = [NSFontAttributeName:font]
        let nsText: NSString = text as NSString
        let frameSize = nsText.boundingRectWithSize(CGSize(width: btnSize.width, height: 2000),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: dict, context: nil).size
        
        result.frame.size = CGSize(width: btnSize.width, height: frameSize.height)
        result.font = font
        result.text = text
        result.alpha = 0.6
        result.textAlignment = NSTextAlignment.Center
        return result
    }
    
    func createBtnLabel(text: String, size: CGSize) -> UILabel {
        var result = UILabel()
        result.frame.size = size
        result.textAlignment = NSTextAlignment.Center
        result.font = UIFont(name: Settings.mainFont, size: size.width/2)
        result.text = text
        result.alpha = 0.6
        
        return result
    }
    
    func getBtnColor() -> UIColor {
        return UIColor(red: 205/255, green: 199/255, blue: 186/255, alpha: 1.0)
    }
    
    func getRndColor() -> UIColor
    {
        var red:CGFloat = CGFloat(random() % 256)/255
        red = min(1, red + 0.2)
        var green:CGFloat = CGFloat(random() % 256)/255
        green = min(1, green + 0.2)
        var blue:CGFloat = CGFloat(random() % 256)/255
        blue = min(1, blue + 0.2)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}