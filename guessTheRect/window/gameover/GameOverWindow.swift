//
//  GameOverWindow.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 7/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol GameOverWindowDelegate {
    func gameOverTouched()
}

class GameOverWindow: UIView {
    var pic: UIView!
    
    var delegate: GameOverWindowDelegate?
    var score: Int!
    var level: Int!
    
    init(score: Int, level: Int)
    {
        super.init()
        self.score = score
        self.level = level
        self.frame.size = GameOverSettings.WINDOW_SIZE
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
            ensureDelegate.gameOverTouched()
        }
    }
    
    
    //private methods
    
    func customizeView() {
        
        //title text
        var textFieldSize = CGSize(width: self.frame.size.width, height: GameOverSettings.TITLE_TEXT_SIZE)
        var font = UIFont(name: GameOverSettings.FONT, size: GameOverSettings.TITLE_TEXT_SIZE)!
        let title = self.createTextField(self.getGameOverText(), textColor: Colors.orangeTextColor(), font: font)
        title.frame.origin.x = self.frame.size.width/2 - title.frame.size.width/2
        title.frame.origin.y = GameOverSettings.TITLE_Y
        
        
        //score text
        let scoreLabel = self.createTextField("SCORE")
        scoreLabel.frame.origin.x = GameOverSettings.SCORE_TEXT_X_CENTER - scoreLabel.frame.size.width/2
        scoreLabel.frame.origin.y = GameOverSettings.SCORE_TEXT_Y
        
        font = UIFont(name: GameOverSettings.FONT, size: GameOverSettings.SCORE_VALUE_TEXT_SIZE)!
        let scoreValueLabel = self.createTextField(String(self.score), font: font)
        scoreValueLabel.frame.origin.x = GameOverSettings.SCORE_VALUE_TEXT_X_CENTER - scoreValueLabel.frame.size.width/2
        scoreValueLabel.frame.origin.y = GameOverSettings.SCORE_VALUE_TEXT_Y
        

        if (PlayerData.instance().getBestScore() <= self.score) {
            self.addBestIcon(CGPoint(x: scoreValueLabel.frame.origin.x + scoreValueLabel.frame.size.width + 20, y: GameOverSettings.SCORE_TEXT_Y))
        }

        
        
        //best score text
        let bestScoreLabel = self.createTextField("LEVEL")
        bestScoreLabel.frame.origin.x = GameOverSettings.SCORE_TEXT_X_CENTER - bestScoreLabel.frame.size.width/2
        bestScoreLabel.frame.origin.y = GameOverSettings.LEVEL_TEXT_Y

        font = UIFont(name: GameOverSettings.FONT, size: GameOverSettings.SCORE_VALUE_TEXT_SIZE)!
        let bestScoreValueLabel = self.createTextField(String(self.level), font: font)
        bestScoreValueLabel.frame.origin.x = GameOverSettings.SCORE_VALUE_TEXT_X_CENTER - bestScoreValueLabel.frame.size.width/2
        bestScoreValueLabel.frame.origin.y = GameOverSettings.LEVEL_VALUE_TEXT_Y


        
        //tap to restart text
        textFieldSize = CGSize(width: self.frame.size.width, height: Settings.TUTOR_TEXT_SIZE)
        font = UIFont(name: Settings.tutorFont, size: Settings.TUTOR_TEXT_SIZE)!
        let continueLabel = self.createTextField("tap to restart", textColor: Colors.orangeTextColor(), font: font)
        continueLabel.frame.origin.x = self.frame.size.width/2 - continueLabel.frame.size.width/2
        continueLabel.frame.origin.y = self.frame.size.height - GameOverSettings.BOTTOM_TEXT_GAP - continueLabel.frame.size.height
    }
    
    
    func createTextField(text: String) -> UILabel {
        let font = UIFont(name: GameOverSettings.FONT, size: GameOverSettings.TEXT_SIZE)
        return self.createTextField(text, textColor: UIColor.blackColor(), font: font!)
    }
    func createTextField(text: String, font: UIFont) -> UILabel {
        return self.createTextField(text, textColor: UIColor.blackColor(), font: font)
    }
    func createTextField(text: String, textColor: UIColor,  font: UIFont) -> UILabel {
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
    
    func addBestIcon(position: CGPoint) {
        let image  = UIImage(named: self.getImageName())
        self.pic = UIImageView(image: image)
        pic.frame.origin = position
        
        self.addSubview(pic)
    }
    
    func getImageName() -> String {
        return "best.png"
    }
    
    func getGameOverText() -> String {
        return "GAME OVER"
    }

}
