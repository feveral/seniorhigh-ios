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
        super.viewDidLoad()
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = Config.Application.adTestDevices;
        view.backgroundColor = .clear
        Theme.addGradientBackground(to: view)
        configureTabBar()
        setStatusBarBackgroundColor(Theme.backgroundTop)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func configureTabBar() {
        tabBar.layer.cornerRadius = 24
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = Theme.shadowColor
        tabBar.layer.shadowOpacity = 0.4
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
        tabBar.layer.shadowRadius = 18
        tabBar.itemPositioning = .automatic
    }

    func setStatusBarBackgroundColor(_ color: UIColor) {
        if let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.backgroundColor = color
            view.addSubview(statusBarView)
        } else {
            // fallback for earlier stage when window is not available
            if let statusBarFrame = UIApplication.shared.statusBarFrame as CGRect? {
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.backgroundColor = color
                view.addSubview(statusBarView)
            }
        }
    }
}
