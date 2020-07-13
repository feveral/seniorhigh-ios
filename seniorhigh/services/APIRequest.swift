//
//  APIRequest.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/10.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}


class APIRequest <T: Codable>{
    
    var url: URL
    var codableClass: T.Type
    
    init(endpoint: String, codableClass: T.Type) {
        self.url = URL(string: Config.Application.apiURL + endpoint)!
        self.codableClass = codableClass
    }
    
    func get(completion: @escaping (Result<T, APIError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
            do {
                let codableObject = try JSONDecoder().decode(self.codableClass.self, from: jsonData)
                completion(.success(codableObject))
            } catch {
                completion(.failure(.decodingProblem))
            }
        }
        task.resume()
    }
    
    func post(toSend: T, completion: @escaping (Result<T, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content/Type")
            urlRequest.httpBody = try JSONEncoder().encode(toSend)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let jsonData = data else {
                        completion(.failure(.responseProblem))
                        return
                }
                do {
                    let codableObject = try JSONDecoder().decode(self.codableClass.self, from: jsonData)
                    completion(.success(codableObject))
                } catch {
                    completion(.failure(.decodingProblem))
                }
            }
            task.resume()
        }
        catch {
            completion(.failure(.encodingProblem))
        }
    }
    
}
