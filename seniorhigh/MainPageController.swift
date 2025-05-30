//
//  MainPageController.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/12.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AdSupport

class MainPageController: UITabBarController {
    
    override func viewDidLoad() {
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = Config.Application.adTestDevices;
    }
}
