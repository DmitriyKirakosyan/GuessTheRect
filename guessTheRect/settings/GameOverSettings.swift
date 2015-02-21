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
        return "Tw Cen MT Condensed"
    }
    
    class var TITLE_TEXT_SIZE: CGFloat {
        return Settings.convertVirtualToRealByWidth(100);
    }
    
    class var TEXT_SIZE: CGFloat {
        return Settings.convertVirtualToRealByWidth(60)
    }
    
    class var SCORE_VALUE_TEXT_SIZE: CGFloat {
        return Settings.convertVirtualToRealByWidth(80)
    }
    
    class var TITLE_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(10)
    }
    
    class var SCORE_TEXT_X_CENTER: CGFloat {
        return Settings.convertVirtualToRealByWidth(220)
    }
    
    class var SCORE_VALUE_TEXT_X_CENTER: CGFloat {
        return Settings.convertVirtualToRealByWidth(380)
    }

    class var SCORE_TEXT_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(140)
    }
    class var SCORE_VALUE_TEXT_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(120)
    }
    

    class var LEVEL_TEXT_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(200)
    }
    class var LEVEL_VALUE_TEXT_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(180)
    }

    class var BOTTOM_TEXT_GAP: CGFloat {
        return Settings.convertVirtualToRealByWidth(10)
    }
    
    class var WINDOW_SIZE: CGSize {
        let width = Settings.convertVirtualToRealByWidth(600)
        let height = Settings.convertVirtualToRealByWidth(400)
        return CGSize(width: width, height: height)
    }
    
    class var BEST_ICON_SIZE: CGSize {
        let width = Settings.convertVirtualToRealByWidth(100)
        let height = Settings.convertVirtualToRealByWidth(50)
        return CGSize(width: width, height: height)
    }



}
