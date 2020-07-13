//
//  MainPageController.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/12.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainPageController: UITabBarController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        interstitial = GADInterstitial(adUnitID: Config.Application.interstitialAdId)
        interstitial.delegate = self
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = Config.Application.adTestDevices;
        let request = GADRequest()
        interstitial.load(request)
    }

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.isReady && Config.Application.isInteritialAdEnable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                ad.present(fromRootViewController: self)
            }
        }
    }
}
