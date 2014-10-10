//
//  ViewController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 22/09/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let SET_3 = 3
    let SET_5 = 5
    
    var difficulty: Int = 0
    var openedTimeout: Int = 10
    var boxesRow:Int = 0
    var randomFront:Bool = false
    let SIDE_OFFSET: CGFloat = 50
    let TOP_OFFSET: CGFloat = 100
    
    var boxSize: CGFloat = 0.0

    var tapAvailable:Bool = true
    var boxes:[Box] = []
    var containerView: UIView = UIView()
    
    var currentOpenedBoxes: [Box] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.frame.origin = CGPoint(x: SIDE_OFFSET, y: TOP_OFFSET)
        //containerView.frame.size = CGSize(width: (self.view.frame.width - SIDE_OFFSET*2), height: (self.view.frame.width - SIDE_OFFSET*2))
        let containerSize: CGFloat = self.view.frame.size.width - SIDE_OFFSET*2
        containerView.frame.size.width = containerSize
        containerView.frame.size.height = self.view.frame.size.width - SIDE_OFFSET*2
        
        containerView.backgroundColor = UIColor.whiteColor()
        
        let boxesRow = difficulty % 2 == 0 ? SET_3 : SET_5
        boxSize = (self.view.frame.size.width - SIDE_OFFSET*2) / CGFloat(boxesRow)
        createBoxes(boxesRow, randomFront: difficulty < 2 ? false : true)
    }
    
    @IBAction func restart(sender: AnyObject) {
        self.createBoxes(self.boxesRow, randomFront: self.randomFront)
    }
    
    func createBoxes(boxesRow: Int, randomFront: Bool)
    {
        self.view.addSubview(containerView)
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
            let hz:CGFloat = newBox.frame.size.width
            let x:CGFloat = CGFloat(i % boxesRow) * boxSize
            let y:CGFloat = CGFloat(Int(i / boxesRow)) * boxSize
            newBox.frame.size = CGSize(width: newBox.frame.size.width, height: newBox.frame.size.height)
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
        }
    }
    
    func hasNotActivated() -> Bool {
        var result = false
        for box in boxes {
            let isBlack = box.backSquare.backgroundColor!.isEqual(UIColor.blackColor())
            if (!box.activated && !isBlack ) {
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
        
        if (boxRow >= 0 && boxRow < boxesRow && boxCol >= 0 && boxCol < boxesRow) { boxes[boxCol + boxRow * boxesRow].open() }
        
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
                    self.blinkView(containerView)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

