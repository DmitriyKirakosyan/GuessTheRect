//
//  PauseWindow.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 16/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol PauseWindowDelegate {
    func pauseWindowTouched()
}

class PauseWindow: UIView {
    var pic: UIView!
    
    var delegate: PauseWindowDelegate?
    
    override init()
    {
        super.init()
        self.frame.size = PauseWindowSettings.WINDOW_SIZE
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = Settings.getCornerRadiusForBitRect(self.frame.size.width)
        self.customizeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let ensureDelegate = self.delegate {
            ensureDelegate.pauseWindowTouched()
        }
    }
    
    
    //private methods
    
    func customizeView() {
        self.placeThePic()
        
        var font = UIFont(name: PauseWindowSettings.FONT, size: PauseWindowSettings.TEXT_SIZE)
        
        //title text
        var textFieldSize = CGSize(width: self.frame.size.width, height: self.pic.frame.origin.y)
        let title = self.createTextField(textFieldSize, text: self.getPauseTitleText(), font: font!)
        title.frame.origin.x = self.frame.size.width/2 - title.frame.size.width/2
        title.frame.origin.y = PauseWindowSettings.TITLE_Y
        
        
        //score text
//        textFieldSize = CGSize(width: self.frame.size.width, height: GameOverSettings.TEXT_SIZE)
//        let scoreText = "Your score : " + String(self.score)
//        let scoreLabel = self.createTextField(textFieldSize, text: scoreText, textColor: Colors.orangeTextColor())
//        scoreLabel.frame.origin.x = self.frame.size.width/2 - scoreLabel.frame.size.width/2
//        scoreLabel.frame.origin.y = GameOverSettings.SCORE_TEXT_Y
//        
//        //best score text
//        textFieldSize = CGSize(width: self.frame.size.width, height: GameOverSettings.TEXT_SIZE)
//        let bestScoreText = "Best score : " + String(PlayerData.instance().getBestScore())
//        let bestScoreLabel = self.createTextField(textFieldSize, text: bestScoreText, textColor: Colors.orangeTextColor())
//        bestScoreLabel.frame.origin.x = self.frame.size.width/2 - bestScoreLabel.frame.size.width/2
//        bestScoreLabel.frame.origin.y = GameOverSettings.BEST_SCORE_TEXT_Y
        
        
        //tap to restart text
        font = UIFont(name: GameOverSettings.FONT, size: GameOverSettings.TEXT_SIZE)

        textFieldSize = CGSize(width: self.frame.size.width, height: GameOverSettings.TEXT_SIZE)
        let continueLabel = self.createTextField(textFieldSize, text: "tap to play", font: font!, textColor: Colors.orangeTextColor())
        continueLabel.frame.origin.x = self.frame.size.width/2 - continueLabel.frame.size.width/2
        continueLabel.frame.origin.y = self.frame.size.height - GameOverSettings.BOTTOM_TEXT_GAP - continueLabel.frame.size.height
    }
    
    
    func createTextField(textSize: CGSize, text: String, font: UIFont) -> UILabel {
        return self.createTextField(textSize, text: text, font: font, textColor: UIColor.blackColor())
    }
    func createTextField(textSize: CGSize, text: String, font: UIFont, textColor: UIColor) -> UILabel {
        var textLabel = UILabel()
        textLabel.font = font
        textLabel.textColor = textColor
        
        //textLabel.frame.size = frameSize
        textLabel.textAlignment = .Center
        textLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = text
        textLabel.sizeToFit()
        
        self.addSubview(textLabel)
        return textLabel;
    }
    
    func placeThePic() {
        
        let image  = UIImage(named: self.getImageName())
        self.pic = UIImageView(image: image)
        pic.frame.origin.x = self.frame.size.width / 2 - pic.frame.size.width/2
        pic.frame.origin.y = self.frame.size.height/2 - pic.frame.size.height/2
        
        self.addSubview(pic)
    }
    
    func getImageName() -> String {
        return "no image"
    }
    
    func getPauseTitleText() -> String {
        return "Pause"
    }

}
