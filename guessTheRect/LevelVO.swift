//
//  LevelVO.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 30/11/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class LevelVO: NSObject {
    var boxesInRow: Int
    var time: Int
    var pairs: Int
    var pairPoints: Int
    var minusPoints: Int
    var closeTime: Int
    var showNumbers: Bool
    
    init(boxesInRow: Int, time: Int, pairs: Int, pairPoints: Int, minusPoints: Int, closeTime: Int,
        showNumbers: Bool) {
        self.boxesInRow = boxesInRow
        self.time = time
        self.pairs = pairs
        self.pairPoints = pairPoints
        self.minusPoints = minusPoints
        self.closeTime = closeTime
        self.showNumbers = showNumbers
    }
}
