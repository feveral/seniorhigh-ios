//
//  DBUtils.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2025/7/11.
//  Copyright © 2025 楊宗翰. All rights reserved.
//
import SQLite

class DBUtils {
    static func toDouble(_ field: SQLite.Binding?) -> Double {
        if let field = field {
            return (field as? NSNumber)?.doubleValue ?? 0.0
        } else {
            return 0.0
        }
    }
}
