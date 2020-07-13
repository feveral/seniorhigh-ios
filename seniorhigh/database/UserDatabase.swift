//
//  FavoritePage.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/28.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import SQLite

class UserDatabase {
    
    static var databaseURL: URL?
    static var db: Connection?
    
    static func getDatabaseConnection() -> Connection? {
        do {

            if let f = databaseURL {
                return try Connection(f.path)
            } else {
                openDatabase()
                return try Connection(databaseURL!.path)
            }
        } catch {
            print("user database connection error: \(error)")
            return nil
        }
    }
    
    static func openDatabase() -> Void {
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        databaseURL = documentsUrl.appendingPathComponent("\(Config.Application.userDBFileName).db")
        if !fileManager.fileExists(atPath: databaseURL!.path) {
            print("User DB does not exist in documents folder")
            do {
                db = try Connection(databaseURL!.path)
                createTable()
            } catch {
                print("UserDB openDatabase Connection Fail")
            }
        }
    }
    
    static func createTable() {
        let sql =
        """
            CREATE TABLE Favorite (
                examine TEXT NOT NULL,
                school TEXT NOT NULL,
                department TEXT NOT NULL
            );
        """
        do {
            try db?.execute(sql)
        } catch {
            print("Create Tabel Favorite Fail")
        }
    }
}
