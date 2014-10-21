//
//  GameBalance.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 15/10/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

class GameBalance {
    class func getMaxScoreForLevel(level: Int) -> Int {
        switch (level) {
        case 1 : return 200
        case 2 : return 200
        case 3 : return 600
        default : return 600
        }
    }
}
