//
//  SoundManager.swift
//  guessTheRect
//
//  Created by Dmitriy on 2/5/15.
//  Copyright (c) 2015 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager {
    
    let SOUND_VOLUME: Float = 0.7
    
    var player: AVAudioPlayer?
    var backgroundPlayer: AVAudioPlayer?
    
    class var sharedInstance :SoundManager {
        struct Singleton {
            static let instance = SoundManager()
        }
        
        return Singleton.instance
    }
    
    func playBackground() {
        var error:NSError?
        self.backgroundPlayer = AVAudioPlayer(contentsOfURL: self.getAudioFile("background", type: "mp3"), error: &error)
        if let sound = backgroundPlayer {
            sound.volume = 0.5
            sound.numberOfLoops = -1
            sound.prepareToPlay()
            sound.play()
        }
    }

    func playFlip() {
        self.playSound("flip", type: "wav")
    }
    func playGameOver() {
        self.playSound("game_over", type: "wav")
    }
    func playLevelComplete() {
        self.playSound("level_complete", type: "mp3")
    }
    func playBackFlip() {
        self.playSound("back_flip", type: "wav")
    }
    
    func playSound(name: String, type: String) {
        var error:NSError?
        self.player = AVAudioPlayer(contentsOfURL: self.getAudioFile(name, type: type), error: &error)
        if let sound = player {
            sound.prepareToPlay()
            sound.volume = SOUND_VOLUME
            sound.play()
        }
    }
    
    func getAudioFile(name: String, type: String) -> NSURL {
        var path = NSBundle.mainBundle().pathForResource(name, ofType: type)
        var result = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: type)!)
        return result!
    }
}