//
//  PlayerData.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 15/10/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import Foundation

private let _instance: PlayerData = PlayerData()

class PlayerData {
    
    let LEVEL_PASS_TIME = "leveLPassTime"
    let LEVEL_SCORE  = "levelScore"
    
    class func instance() -> PlayerData {
        return _instance
    }
    
    func getLevelPassTime(level: Int) -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.integerForKey(LEVEL_PASS_TIME + String(level))
    }
    
    func getLevelScore(level: Int) -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.integerForKey(LEVEL_SCORE + String(level))
    }
    
    func setLevelPassTime(level: Int, passTime: Int) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(passTime, forKey: LEVEL_PASS_TIME + String(level))
        userDefaults.synchronize()
    }
    
    func setLevelScore(level: Int, score: Int) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(score, forKey: LEVEL_SCORE + String(level))
        userDefaults.synchronize()
    }
}
