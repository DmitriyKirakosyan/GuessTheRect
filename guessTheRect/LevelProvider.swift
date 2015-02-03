//
//  Level.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 30/11/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class LevelProvider: NSObject {
    let levels = ["1", "2", "3", "4", "5", "6", "7"]
    let LEVELS_NUM = 25
    var levelVOs: [LevelVO] = []
    
    var currentLevel = 0
    
    class var sharedInstance :LevelProvider {
        struct Singleton {
            static let instance = LevelProvider()
        }
        
        return Singleton.instance
    }
    
    override init() {
        super.init()
        var levelArray: [String] = []
        for index in 1...25 {
            levelArray.append(String(index))
        }
        levelVOs = levelArray.map { self.convertJsonToVO($0) }
    }
    
    func resetLevel() {
        currentLevel = 0
    }
    
    func getNextLevel() -> LevelVO? {
        currentLevel++
        var level: LevelVO? = nil
        if (currentLevel <= levelVOs.count) {
            level = levelVOs[currentLevel-1]
        }
        return level
    }
    
    
    func convertJsonToVO(jsonFile: String) -> LevelVO
    {
        var path = NSBundle.mainBundle().pathForResource(jsonFile, ofType: "json")
    
        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        let time = jsonResult["time"] as Int
        let boxesInRow = jsonResult["boxesInRow"] as Int
        let moves = jsonResult["moves"] as Int
        let pairs = jsonResult["pairs"] as Int
        let pair_points = jsonResult["pair_points"] as Int
        let minus_points = jsonResult["minus_points"] as Int
        
        return LevelVO(boxesInRow: boxesInRow, time: time, pairs: pairs, pairPoints: pair_points, minusPoints: minus_points)
    }
}
