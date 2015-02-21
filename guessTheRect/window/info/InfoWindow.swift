//
//  InfoWindow.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 19/01/2015.
//  Copyright (c) 2015 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

protocol InfoWindowDelegate {
    func windowTouched()
}

class InfoWindow : UIView {
    var pic: UIView!
    var message: String!
    var icon: String!
    var delegate: InfoWindowDelegate?
    
    init(message: String, icon: String)
    {
        super.init()
        self.message = message
        self.icon = icon
        self.frame.size = Settings.getInfoWindowSize(message)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = Settings.getCornerRadiusForBitRect(self.frame.size.width)
        self.customizeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let ensureDelegate = self.delegate {
            ensureDelegate.windowTouched()
        }
    }
    
    
    //private methods
    
    func customizeView() {
        self.placeThePic()
        
        var textFieldSize = CGSize(width: self.frame.size.width, height: self.pic.frame.origin.y)
        self.createTextField(textFieldSize, text: self.message)
        
        textFieldSize = CGSize(width: self.frame.size.width, height: Settings.TUTOR_TEXT_SIZE)
        let bottomPosition = CGPoint(x: 0, y: self.frame.size.height - Settings.TUTOR_TEXT_SIZE - Settings.TUTOR_BOTTOM_TEXT_GAP)
        self.createTextField(textFieldSize, origin: bottomPosition, text: "tap to continue", textColor: Colors.orangeTextColor())
    }
    
    
    func createTextField(frameSize: CGSize, text: String) {
        self.createTextField(frameSize, origin: CGPoint(), text: text, textColor: UIColor.blackColor())
    }
    func createTextField(frameSize: CGSize, origin: CGPoint, text: String, textColor: UIColor) {
        var textLabel = UILabel()
        textLabel.font = UIFont(name: Settings.tutorFont, size: Settings.TUTOR_TEXT_SIZE)
        textLabel.textColor = textColor
        
        textLabel.frame.size = frameSize
        textLabel.frame.origin = origin
        textLabel.textAlignment = .Center
        textLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = text
        
        self.addSubview(textLabel)
    }
    
    func placeThePic() {
        
        let image  = UIImage(named: self.icon)
        self.pic = UIImageView(image: image)
        pic.frame.origin.x = self.frame.size.width / 2 - pic.frame.size.width/2
        pic.frame.origin.y = self.frame.size.height/2 - pic.frame.size.height/2
        
        self.addSubview(pic)
    }
    
}