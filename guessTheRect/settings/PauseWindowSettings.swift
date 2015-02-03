//
//  PauseWindowSettings.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 16/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class PauseWindowSettings {

    class var FONT: String {
        return "Tw Cen MT Condensed"
    }

    class var TEXT_SIZE: CGFloat {
        return Settings.convertVirtualToRealByWidth(160)
    }

    class var WINDOW_SIZE: CGSize {
        let width = Settings.convertVirtualToRealByWidth(500)
        let height = Settings.convertVirtualToRealByWidth(300)
        return CGSize(width: width, height: height)
    }
    
    class var TITLE_Y: CGFloat {
        return Settings.convertVirtualToRealByWidth(20)
    }


}
