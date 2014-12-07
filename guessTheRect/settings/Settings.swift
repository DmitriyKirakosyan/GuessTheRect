//
//  Settings.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 20/10/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class Settings {
    
    class var mainFont: String {
        return "Tw Cen MT Condensed"
    }
    
    class var tutorFont: String {
        return "Kristen ITC"
    }
    
    class var DEFAULT_SCREEN_WIDTH: CGFloat {
        return 768
    }
    class var DEFAULT_SCREEN_HEIGHT: CGFloat {
        return 1024
    }
    
    class var REAL_SCREEN_WIDTH: CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }

    class var REAL_SCREEN_HEIGHT: CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }

    class var GAME_FIELD_SIDE_OFFSET: CGFloat {
        return convertVirtualToRealByWidth(30)
    }
    class var GAME_FIELD_BACK_CONTAINER_OFFSET: CGFloat {
        return convertVirtualToRealByWidth(10)
    }
    
    class var GAME_FIELD_TOP_OFFSET: CGFloat {
        return convertVirtualToRealByWidth(130) + BANNER_HEIGHT
    }
    
    
    class var INFO_PANEL_Y_OFFSET: CGFloat {
        return self.convertVirtualToRealByWidth(10) + BANNER_HEIGHT
    }
    
    class var TEXT_SIZE: CGFloat {
        return self.convertVirtualToRealByWidth(55)
    }
    
    class var MENU_BUTTONS_Y_OFFSET: CGFloat {
        return REAL_SCREEN_HEIGHT - convertVirtualToRealByWidth(8) - MENU_BUTTONS_SIZE
    }
    
    class var MENU_BUTTONS_X_OFFSET: CGFloat {
        return convertVirtualToRealByWidth(50)
    }
    
    class var MENU_BUTTONS_SIZE: CGFloat {
        return convertVirtualToRealByWidth(110)
    }
    
    class var BOXES_GAP: CGFloat {
        return convertVirtualToRealByWidth(5)
    }
    
    // Tutor window

    class var TUTOR_TEXT_SIZE: CGFloat {
        return convertVirtualToRealByWidth(40)
    }
    
    class var TUTOR_BOTTOM_TEXT_GAP: CGFloat {
        return convertVirtualToRealByWidth(10)
    }

    
    // functions
    
    class func getTutorWindowSize(tutorSte: TutorStep) -> CGSize {
        let width = convertVirtualToRealByWidth(600)
        let height = convertVirtualToRealByWidth(500)
        return CGSize(width: width, height: height)
    }
    
    class func getBoxSize(boxesRow: Int) -> CGFloat {
        return (REAL_SCREEN_WIDTH - GAME_FIELD_SIDE_OFFSET*2) / CGFloat(boxesRow) - BOXES_GAP
    }
    
    class func getCornerRadius(rectSize: CGFloat) -> CGFloat
    {
        return rectSize / 20
    }
    
    class func getCornerRadiusForBitRect(rectSize: CGFloat) -> CGFloat {
        return rectSize / 50
    }
    
    
    
    class func convertVirtualToRealByWidth(point: CGFloat) -> CGFloat
    {
        let widthDiff = REAL_SCREEN_WIDTH / DEFAULT_SCREEN_WIDTH
        return point * widthDiff
    }

    class func convertVirtualToRealByHeight(point: CGFloat) -> CGFloat
    {
        let heightDiff = REAL_SCREEN_HEIGHT / DEFAULT_SCREEN_HEIGHT
        return point * heightDiff
    }
    
    
    class var BANNER_HEIGHT: CGFloat {
        return UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 50 : 66
    }

}