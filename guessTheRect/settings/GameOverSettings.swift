//
//  GameOverSettings.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 7/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class GameOverSettings {
    class var FONT: String {
        return "Kristen ITC"
    }
    
    class var TEXT_SIZE: CGFloat {
        return Settings.convertVirtualToRealByWidth(40)
    }
    
    class var TITLE_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(10)
    }
    
    class var SCORE_TEXT_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(100)
    }

    class var BEST_SCORE_TEXT_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(180)
    }

    class var BOTTOM_TEXT_GAP: CGFloat {
        return Settings.convertVirtualToRealByWidth(10)
    }
    
    class var WINDOW_SIZE: CGSize {
        let width = Settings.convertVirtualToRealByWidth(600)
        let height = Settings.convertVirtualToRealByWidth(500)
        return CGSize(width: width, height: height)
    }



}
