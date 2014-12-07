//
//  GameOverController.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 7/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol GameOverControllerDelegate {
    func gameOverFinished()
}

class GameOverController: GameOverWindowDelegate {
    
    var container: UIView
    var shadowView: UIView
    var window: GameOverWindow!
    
    var delegate: GameOverControllerDelegate?
    
    var score: Int
    
    init(container: UIView, score: Int) {
        self.container = container
        
        self.shadowView = Utils.createBlurScreen(container)
        
        self.score = score
        
        //self.container.addSubview(self.shadowView)
    }
    
    func showGameOver() {
        self.window = GameOverWindow(score: score)
        window.frame.origin = CGPoint(x: self.container.frame.size.width/2 - window.frame.size.width/2, y: self.container.frame.size.height/2 - window.frame.size.height/2)
        window.delegate  = self
        let hz = UIView()
        hz.frame.size = self.container.frame.size
        hz.addSubview(window)
        self.container.addSubview(hz)
    }
    
    func gameOverTouched() {
        UIView.animateWithDuration(1.5, animations: {
            self.shadowView.alpha = 0
            self.window.alpha = 0
        }, completion: { finished in
                self.shadowView.removeFromSuperview()
                self.window.removeFromSuperview()
            if let listener = self.delegate {
                listener.gameOverFinished()
            }
        })

        //remove from container
    }
}
