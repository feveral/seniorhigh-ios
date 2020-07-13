//
//  GradeDatabase.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/12.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import SQLite

class GradeDatabase {
    
    static var finalDatabaseURL: URL?
    static var db: Connection?
    
    static func getDatabaseConnection() -> Connection? {
        do {
            if let f = finalDatabaseURL {
                return try Connection(f.path)
            } else {
                openDatabase()
                return try Connection(finalDatabaseURL!.path)
            }
        } catch {
            print("grade database connection error: \(error)")
            return nil
        }
    }
    
    static func openDatabase() -> Void {
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        GradeDatabase.finalDatabaseURL = documentsUrl.appendingPathComponent("\(Config.Application.gradeDBFileName).db")
        do {
            if !fileManager.fileExists(atPath: GradeDatabase.finalDatabaseURL!.path) {
                print("DB does not exist in documents folder")
                
                if let dbFilePath = Bundle.main.path(forResource: Config.Application.gradeDBFileName, ofType: "db") {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: GradeDatabase.finalDatabaseURL!.path)
                } else {
                    print("Uh oh - \(Config.Application.gradeDBFileName).db is not in the app bundle")
                }
            } else {
                print("Database file found at path: \(GradeDatabase.finalDatabaseURL!.path)")
            }
        } catch {
            print("Unable to copy \(Config.Application.gradeDBFileName).db: \(error)")
        }
    }
}
