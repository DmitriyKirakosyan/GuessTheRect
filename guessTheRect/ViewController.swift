//
//  ViewController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 22/09/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, InfoPanelProtocol, ADBannerViewDelegate {
    let SET_3 = 3
    let SET_5 = 5
    
    var difficulty: Int = 0
    var openedTimeout: Int = 10
    var boxesRow:Int = 0
    var randomFront:Bool = false
    let SIDE_OFFSET: CGFloat = 50
    let TOP_OFFSET: CGFloat = 100
    
    let MAIN_CONTAINER_OFFSET: CGFloat = 10
    
    var boxSize: CGFloat = 0.0
    
    var infoView: InfoPanelView?

    var tapAvailable:Bool = true
    var boxes:[Box] = []
    var containerView: UIView = UIView()
    
    var currentOpenedBoxes: [Box] = []
    
    var bannerView: ADBannerView?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initGame()
        self.addBanner()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func addBanner() {
        if ADBannerView.instancesRespondToSelector(Selector("initWithAdType:")) {
            bannerView = ADBannerView(adType: .Banner)
        } else {
            bannerView = ADBannerView()
        }
        bannerView?.delegate = self
        
        bannerView!.frame.origin.y = self.view.frame.size.height - bannerView!.frame.size.height
        self.view.addSubview(bannerView!)
    }
    
    func initGame() {
        containerView.frame.origin = CGPoint(x: SIDE_OFFSET, y: TOP_OFFSET)
        let containerSize: CGFloat = self.view.frame.size.width - SIDE_OFFSET*2
        containerView.frame.size.width = containerSize
        containerView.frame.size.height = self.view.frame.size.width - SIDE_OFFSET*2
        containerView.backgroundColor = Colors.getBackColor()//UIColor.whiteColor()
        
        self.createMainContainer()
        
        self.view.addSubview(containerView)
        
        let boxesRow = difficulty % 2 == 0 ? SET_3 : SET_5
        boxSize = (self.view.frame.size.width - SIDE_OFFSET*2) / CGFloat(boxesRow)
        createBoxes(boxesRow, randomFront: difficulty < 2 ? false : true)
        
        setupTopPanel()
    }
    
    func createMainContainer() {
        let size = containerView.frame.size.width + (MAIN_CONTAINER_OFFSET * 2)
        let pointX = containerView.frame.origin.x - MAIN_CONTAINER_OFFSET
        let pointY = containerView.frame.origin.y - MAIN_CONTAINER_OFFSET
        var mainContainer = UIView()
        mainContainer.frame.origin = CGPoint(x: pointX, y: pointY)
        mainContainer.frame.size = CGSize(width: size, height: size)
        mainContainer.backgroundColor = Colors.getBackColor()
        self.view.addSubview(mainContainer)
    }
    
    func restart() {
        self.createBoxes(self.boxesRow, randomFront: self.randomFront)
        if (infoView != nil) { infoView?.clear() }
    }
    
    func createBoxes(boxesRow: Int, randomFront: Bool)
    {
        if (boxes.count > 0) {
            for box in boxes { box.removeFromSuperview() }
            boxes = []
        }
        self.boxesRow = boxesRow
        self.randomFront = randomFront
        let boxesNum = Int(pow(CGFloat(boxesRow),2))

        let randomColorsNum = (boxesRow == SET_3) ? 4 : 12
        var backColors:[UIColor] =  Colors.getRandomColors(Colors.getRandomSet(), num: randomColorsNum)
        backColors += backColors
        backColors.append(UIColor.blackColor())
        backColors = Colors.shuffle(backColors)
        
        let frontColors = Colors.getRandomColors(Colors.getRandomSet(), num: boxesNum)
        
        for i in 0...boxesNum-1 {

            var newBox:Box
            if (randomFront)
            {
                let frontColor = frontColors[i]
                let backColor = backColors[i]
                newBox = Box(frontColor: frontColor, backColor: backColor, size: boxSize)
            }
            else
            {
                newBox = Box(backColor: backColors[i], size: boxSize)
            }
            let x:CGFloat = CGFloat(i % boxesRow) * boxSize
            let y:CGFloat = CGFloat(Int(i / boxesRow)) * boxSize
            newBox.frame.origin = CGPoint(x: x, y: y)
            containerView.addSubview(newBox)
            boxes += [newBox]
        }
    }
    
    func setupTopPanel() {
        let topPanel = NSBundle.mainBundle().loadNibNamed("InfoPanel", owner: self, options: nil)
        infoView = topPanel[0] as? InfoPanelView
        infoView!.delegate = self
        println(self.view.frame.size.width - infoView!.frame.size.width)
        infoView!.frame.size.width = self.view.frame.size.width
        self.view.addSubview(infoView!)
        infoView!.scoreLabel.frame.size.width += self.view.frame.size.width - infoView!.frame.size.width
        infoView!.clear()
    }
    
    func createRandomColor() -> UIColor
    {
        let red:CGFloat = CGFloat(random() % 256)/255
        let green:CGFloat = CGFloat(random() % 256)/255
        let blue:CGFloat = CGFloat(random() % 256)/255
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    func closeBoxes(timer:NSTimer)
    {
        let boxes:[Box] = currentOpenedBoxes//timer.userInfo as [Box]
        boxes[0].close()
        boxes[1].close()
        tapAvailable = true
        
    }
    
    func closeActivatedBoxes(timer: NSTimer) {
        if self.hasNotActivated() {
            let boxes:[Box] = timer.userInfo as [Box]
            boxes[0].close()
            boxes[0].deactivate()
            boxes[1].close()
            boxes[1].deactivate()
            infoView?.decreaseScore()
        }
    }
    
    func hasNotActivated() -> Bool {
        var result = false
        for box in boxes {
            if (!box.activated && !box.isEmpty() ) {
                result = true
                break
            }
        }
        return result
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if (!tapAvailable) { return }
        //open box
        let touch = touches.allObjects[0] as UITouch
        let touchLocation = touch.locationInView(self.view)
        let boxRow: Int = Int((touchLocation.y - TOP_OFFSET) / boxSize);
        let boxCol: Int = Int((touchLocation.x - SIDE_OFFSET) / boxSize);
        
        if (boxRow >= 0 && boxRow < boxesRow && boxCol >= 0 && boxCol < boxesRow) {
            boxes[boxCol + boxRow * boxesRow].open()
            if !infoView!.isTimerRunning() && self.hasNotActivated() { infoView!.startTimer() }
        }
        
        //check boxes
        var openedBoxes:[Box] = []
        for box in boxes {
            if (box.opened && !box.activated)
            {
                openedBoxes += [box]
            }
        }
        if (openedBoxes.count > 1)
        {
            if (openedBoxes[0].backSquare.backgroundColor == openedBoxes[1].backSquare.backgroundColor)
            {
                openedBoxes[0].activate();
                openedBoxes[1].activate();
                self.blinkView(openedBoxes[0])
                self.blinkView(openedBoxes[1])
                
                if (self.hasNotActivated()) {
                    let selector : Selector = "closeActivatedBoxes:"
                    var timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(10.0), target: self, selector:  selector, userInfo: NSArray(array: openedBoxes), repeats: false)
                } else {
                    //level complete
                    self.blinkView(containerView)
                    self.stopGame()
                    self.saveScore()
                }
            }
            else
            {
                tapAvailable = false;
                let interval: NSTimeInterval = 0.5
                self.currentOpenedBoxes = openedBoxes
                var timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector:  Selector("closeBoxes:"), userInfo: NSArray(array: openedBoxes), repeats: false)
            }
        }
    }
    
    func blinkView(view: UIView) {
        let animationOptions:UIViewAnimationOptions = .CurveEaseIn
        var whiteView = UIView()
        whiteView.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        
        whiteView.backgroundColor = UIColor.clearColor()
        view.addSubview(whiteView)
        UIView.animateWithDuration(0.3, delay: 0, options: animationOptions, animations: {
            whiteView.backgroundColor = UIColor.whiteColor()
            }, completion: { (finished: Bool) in
                
                UIView.animateWithDuration(0.6, delay: 0, options: animationOptions, animations: {
                    whiteView.backgroundColor = UIColor.clearColor()
    
                    }, completion: { (finished: Bool) in whiteView.removeFromSuperview() })
            })
    }
    
    
    func stopGame() {
        infoView?.stopTimer()
    }
    
    func saveScore() {
        if (infoView != nil) {
            PlayerData.instance().setLevelPassTime(difficulty+1, passTime: infoView!.getTime())
            PlayerData.instance().setLevelScore(difficulty+1, score: infoView!.getScore())  
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func maxScore() -> Int {
        return GameBalance.getMaxScoreForLevel(difficulty+1)
    }
    
    func gotToMenu() {
        self.performSegueWithIdentifier("toMenu", sender: self)
    }

    
    func bannerViewDidLoadAd(banner: ADBannerView)
    {

        //self layoutAnimated:YES];
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!)
    {
      
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool
    {
        infoView?.stopTimer()
        return true
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!)
    {
        infoView?.startTimer()
        infoView?.updateSize()
    }

}

