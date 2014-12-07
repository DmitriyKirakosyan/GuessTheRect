//
//  Utils.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 7/12/2014.
//  Copyright (c) 2014 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit

class Utils {
    
    class var BLUR_STREIGHT: Int { return 4 }
    
    class func createBlurScreen(screenView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(screenView.bounds.size, true, 0)
        screenView.layer.renderInContext(UIGraphicsGetCurrentContext())
        var imgaa :UIImage = UIGraphicsGetImageFromCurrentImageContext();
        var ciimage :CIImage = CIImage(image: imgaa)
        var filter : CIFilter = CIFilter(name:"CIGaussianBlur")
        filter.setDefaults()
        
        filter.setValue(ciimage, forKey: kCIInputImageKey)
        filter.setValue(BLUR_STREIGHT, forKey: kCIInputRadiusKey)
        
        var outputImage : CIImage = filter.outputImage;
        var finalImage = UIImage(CIImage: outputImage)
        
        let result = UIImageView(image: finalImage)
        result.frame.size = screenView.frame.size
        return result
    }
}

