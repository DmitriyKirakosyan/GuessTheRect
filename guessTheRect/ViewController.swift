//
//  ViewController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 22/09/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, InfoPanelProtocol, ADBannerViewDelegate, ScoreManagerDelegate, TutorControllerDelegate {
    let SET_3 = 3
    let SET_5 = 5
    
    var difficulty: Int = 0
    var openedTimeout: Int = 10
    var boxesRow:Int = 0
    var randomFront:Bool = false
    
    var currentLevel: LevelVO!
    var boxesOpened: Int = 0
    
    var infoView: InfoPanelView?
    var scoreManager: ScoreManager!
    
    var restartBtn: UIButton!

    var tapAvailable:Bool = true
    var boxes:[Box] = []
    var containerView: UIView = UIView()
    
    var currentOpenedBoxes: [Box] = []
    
    var bannerView: ADBannerView?;
    
    var gameStarted: Bool = false
    var isGameOver: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBanner()
        self.setupMenuButtons()
        self.setupScoreManager()
        self.startNextLevelSafe()
        self.showTutor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func levelCompleted() {
        self.startNextLevelSafe()
    }
    
    func gameOver() {
        self.blinkView(containerView)
        self.stopGame()
        self.saveScore()
        LevelProvider.sharedInstance.resetLevel()
        self.isGameOver = true
    }
    
    func showTutor()
    {
        self.tapAvailable = false
        self.restartBtn.hidden = true
        
        let tutorController = TutorController(container: self.view)
        tutorController.delegate = self
        tutorController.startTutorial()
    }
    
    func startNextLevelSafe() {
        var levelVO = LevelProvider.sharedInstance.getNextLevel()
        if let existsLevelVO = levelVO {
            self.startLevel(existsLevelVO)
        }
    }
    
    func addBanner() {
        if ADBannerView.instancesRespondToSelector(Selector("initWithAdType:")) {
            bannerView = ADBannerView(adType: .Banner)
        } else {
            bannerView = ADBannerView()
        }
        bannerView?.delegate = self
        
        
        println(bannerView!.frame.size.height)
        
        //bannerView!.frame.origin.y = self.view.frame.size.height - bannerView!.frame.size.height
        self.view.addSubview(bannerView!)
    }
    
    func setupScoreManager() {
        //infoPanel
        let infoViewFrame = CGRect(x: 0, y: Settings.INFO_PANEL_Y_OFFSET,
            width: self.view.frame.size.width, height: self.view.frame.size.height/10)
        infoView = InfoPanelView(frame: infoViewFrame, sideOffset: Settings.GAME_FIELD_SIDE_OFFSET)
        self.view.addSubview(infoView!)
        
        scoreManager = ScoreManager(infoPanel: infoView!)
        scoreManager.delegate = self
    }
    
    func setupMenuButtons() {
        restartBtn = UIButton()
        let image = UIImage(named: "restartBtn") as UIImage?
        restartBtn.setImage(image, forState: .Normal)

        restartBtn.frame.size = CGSize(width: Settings.MENU_BUTTONS_SIZE, height: Settings.MENU_BUTTONS_SIZE)
        restartBtn.frame.origin.x = self.view.frame.size.width - restartBtn.frame.size.width - Settings.GAME_FIELD_SIDE_OFFSET
        restartBtn.frame.origin.y = Settings.MENU_BUTTONS_Y_OFFSET
        
        restartBtn.addTarget(self, action: "restart", forControlEvents:.TouchUpInside)
        self.view.addSubview(restartBtn)

    }
    
    func startLevel(levelVO: LevelVO) {
        currentLevel = levelVO
        scoreManager.setLevel(levelVO)
        
        containerView.frame.origin = CGPoint(x: Settings.GAME_FIELD_SIDE_OFFSET, y: Settings.GAME_FIELD_TOP_OFFSET)
        let containerSize: CGFloat = self.view.frame.size.width - Settings.GAME_FIELD_SIDE_OFFSET*2
        containerView.frame.size.width = containerSize
        containerView.frame.size.height = self.view.frame.size.width - Settings.GAME_FIELD_SIDE_OFFSET*2
        containerView.backgroundColor = Colors.getBackColor()//UIColor.whiteColor()
        
        self.createMainContainer()
        
        self.view.addSubview(containerView)
        
        self.boxesRow = currentLevel.boxesInRow
        createBoxes(false)
        
    }
    
    func createMainContainer() {
        let containerOffset = Settings.GAME_FIELD_BACK_CONTAINER_OFFSET
        let size = containerView.frame.size.width + (containerOffset * 2)
        let pointX = containerView.frame.origin.x - containerOffset
        let pointY = containerView.frame.origin.y - containerOffset
        var mainContainer = UIView()
        mainContainer.frame.origin = CGPoint(x: pointX, y: pointY)
        mainContainer.frame.size = CGSize(width: size, height: size)
        mainContainer.backgroundColor = Colors.getBackColor()
        mainContainer.layer.cornerRadius = Settings.getCornerRadiusForBitRect(mainContainer.frame.size.width);
        self.view.addSubview(mainContainer)
    }
    
    func restart() {
        LevelProvider.sharedInstance.resetLevel()
        self.gameStarted = false
        self.startNextLevelSafe()
        self.scoreManager.gameDidRestart()
    }
    
    func createBoxes(randomFront: Bool)
    {
        if (boxes.count > 0) {
            for box in boxes { box.removeFromSuperview() }
            boxes = []
        }
        self.randomFront = randomFront
        let boxesNum = Int(pow(CGFloat(boxesRow),2))

        let randomColorsNum = (boxesRow == SET_3) ? 4 : 12
        var backColors:[UIColor] =  Colors.getRandomColors(Colors.getRandomSet(), num: randomColorsNum)
        backColors += backColors
        backColors.append(Colors.getEmptyBoxColor())
        backColors = Colors.shuffle(backColors)
        
        let frontColors = Colors.getRandomColors(Colors.getRandomSet(), num: boxesNum)
        
        for i in 0...boxesNum-1 {

            var newBox:Box
            var boxSize = Settings.getBoxSize(boxesRow)
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
            let startCoord: CGFloat = Settings.BOXES_GAP / 2
            let x:CGFloat = startCoord + CGFloat(i % boxesRow) * (boxSize + Settings.BOXES_GAP)
            let y:CGFloat = startCoord + CGFloat(Int(i / boxesRow)) * (boxSize + Settings.BOXES_GAP)
            newBox.frame.origin = CGPoint(x: x, y: y)
            containerView.addSubview(newBox)
            boxes += [newBox]
        }
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
            scoreManager.pairDidClose()
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
        
        if isGameOver {
            self.restart()
            isGameOver = false
            return
        }
        
        //open box
        let touch = touches.allObjects[0] as UITouch
        let touchLocation = touch.locationInView(self.view)

        
        let boxRow: Int = Int((touchLocation.y - Settings.GAME_FIELD_TOP_OFFSET) / (Settings.getBoxSize(boxesRow) + Settings.BOXES_GAP));
        let boxCol: Int = Int((touchLocation.x - Settings.GAME_FIELD_SIDE_OFFSET) / (Settings.getBoxSize(boxesRow) + Settings.BOXES_GAP));
        
        if (boxRow >= 0 && boxRow < boxesRow && boxCol >= 0 && boxCol < boxesRow) {
            boxes[boxCol + boxRow * boxesRow].open()
            
            if !gameStarted {
                gameStarted = true
                scoreManager.gameDidStart()
            }
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
                
                scoreManager.pairDidComplete()
                let selector : Selector = "closeActivatedBoxes:"
                var timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(10.0), target: self, selector:  selector, userInfo: NSArray(array: openedBoxes), repeats: false)
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
        whiteView.layer.cornerRadius = view.layer.cornerRadius
        
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
        scoreManager.pause()
        return true
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!)
    {
        scoreManager.resume()
    }
    
    // tutor delegate
    
    func tutorFinished() {
        self.restartBtn.hidden = false
        self.tapAvailable = true
    }

}

