//
//  UIUtils.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2023/1/14.
//  Copyright © 2023 楊宗翰. All rights reserved.
//

import Foundation
import UIKit

class UIUtils {
    static func getCurrentViewController() -> UIViewController {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
}
