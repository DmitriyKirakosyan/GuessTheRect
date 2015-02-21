//
//  AdManager.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 18/02/2015.
//  Copyright (c) 2015 Dmitriy Kirakosyan. All rights reserved.
//

import UIKit
import iAd


protocol AdManagerDelegate {
    func adDidLoad()
    func adDidUnload()
}

class AdManager: NSObject, ADInterstitialAdDelegate {
    var mainView: UIView!
    var interstitial: ADInterstitialAd!
    var placeHolder: UIView!
    var closeButton: UIButton!
    
    let NUM_COMPLETIONS_FOR_AD_SHOWING = 3;
    var levelCompletionCounter: Int = 0
    
    var delegate: AdManagerDelegate?
    
    init(mainView: UIView)
    {
        super.init()
        self.mainView = mainView;
    }
    
    /**
        The manager decides whether to show the add after the level completion
    */
    func gameOverReached() {
        levelCompletionCounter++
        if (levelCompletionCounter >= NUM_COMPLETIONS_FOR_AD_SHOWING)
        {
            levelCompletionCounter = 0
            self.showFullScreenAd()
        }
    }
    
    
    func showFullScreenAd() {
        interstitial = ADInterstitialAd()
        interstitial.delegate = self
        
    }
    
    
    // ADInterstitialAdDelegate
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        self.close()
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        self.close()
    }
    
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        self.close()
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        if let listener = self.delegate {
            listener.adDidLoad()
        }

        placeHolder = UIView(frame: mainView.frame)
        mainView.addSubview(placeHolder)
        
        closeButton = UIButton(frame: CGRect(x: 270, y:  25, width: 25, height: 25))
        closeButton.setBackgroundImage(UIImage(named: "error"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: Selector("close"), forControlEvents: UIControlEvents.TouchDown)
        mainView.addSubview(closeButton)
        
        
        interstitial.presentInView(placeHolder)
    }
    
    func close()
    {
        placeHolder.removeFromSuperview()
        closeButton.removeFromSuperview()
        interstitial = nil
        if let listener = self.delegate {
            listener.adDidUnload()
        }
    }
}
