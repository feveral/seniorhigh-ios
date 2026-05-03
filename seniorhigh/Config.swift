//
//  Config.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/10.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation


struct Config {
    static let Application = ApplicationConfig()
    static let Text = TextConfig()
}

struct TextConfig {
    let DESIGNATED = "Designated"
    let BASIC = "Basic"
    let UNIFY = "Unify"
}

struct ApplicationConfig {
    let apiURL = "http://seniorhigh.feveral.idv.tw/api/"
    let designatedFirstYear = "114"
    let designatedSecondYear = "113"
    let basicFirstYear = "115"
    let basicSecondYear = "114"
    let unifyFirstYear = "113"
    let unifySecondYear = "112"
    let gradeDBFileName = "grade_2026_0503"
    let userDBFileName = "user"
    let adTestDevices = ["12480dc4f1ac79cd7d05e5b453367555"]
    let mainBannerAdId = "ca-app-pub-7439674685628581/4529433104"
    let interstitialAdId = "ca-app-pub-7439674685628581/4580144816"
    let isInteritialAdEnable = false
}
