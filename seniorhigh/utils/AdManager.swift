//
//  AdManager.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/20.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class AdManager {
    
    
    static func buildBannerView(viewController: UIViewController) -> GADBannerView {
        var bannerView: GADBannerView
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = Config.Application.mainBannerAdId
        bannerView.rootViewController = viewController
        bannerView.load(GADRequest())
        return bannerView
    }
    
    static func addBottomBannerViewToView(view: UIView, bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}
