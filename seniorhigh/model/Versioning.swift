//
//  Version.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/10.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation

class VersioningResponse: Codable {
    var status: Bool
    var versions: [Versioning]
}

class Versioning: Codable {
    var version_code: Int
    var release: Bool
    var examine: String
    var year: Int
    var version_information: String
    var time: String
}
