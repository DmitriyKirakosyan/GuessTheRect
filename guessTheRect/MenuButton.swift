//
//  MenuButton.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 16/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKIt

class MenuButton : UIButton {
    init(imageName: String)
    {
        super.init()
        let image = UIImage(named: imageName) as UIImage?
        self.setImage(image, forState: .Normal)

        self.frame.size = CGSize(width: Settings.MENU_BUTTONS_SIZE, height: Settings.MENU_BUTTONS_SIZE)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
