//
//  TextUtils.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/11.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation

class TextUtil {
    static func examineStringLowerCase(examine: String) -> String {
        if (examine == Config.Text.DESIGNATED) {
            return "designated"
        } else if (examine == Config.Text.BASIC) {
            return "basic"
        } else if (examine == Config.Text.UNIFY) {
            return "unify"
        }
        return ""
    }
}
