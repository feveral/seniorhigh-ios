//
//  VersionService.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/11.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation

class VersioningService {
    static func getLatestVersionings(examine: String, quantity: Int, completion: @escaping (Result<[Versioning], APIError>) -> Void) {
        let examineLowerCase = TextUtil.examineStringLowerCase(examine: examine)
        let apiRequest = APIRequest(endpoint: "version/latest?examine=" + examineLowerCase + "&quantity=" + String(quantity), codableClass: VersioningResponse.self)
        apiRequest.get { result in
            switch result {
            case .success(let versionResponse):
                completion(Result<[Versioning], APIError>.success(versionResponse.versions))
            case .failure(let error):
                completion(Result<[Versioning], APIError>.failure(error))
            }
        }
    }
}
