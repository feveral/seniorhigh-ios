//
//  Favorite.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/9/4.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import SQLite

class Favorite {
    
    var examine: String
    var school: String
    var department: String
    
    init(examine: String, school: String, department: String) {
        self.examine = examine
        self.school = school
        self.department = department
    }
    
    static func dbRowToFavorite(row: [Binding?]) -> Favorite {
        return Favorite(examine: row[0]! as! String, school: row[1]! as! String, department: row[2]! as! String)
    }
    
    static func isFavoriteExist(favorite: Favorite) -> Bool {
        let db: Connection = UserDatabase.getDatabaseConnection()!
        let sql = "SELECT * FROM Favorite WHERE examine='\(favorite.examine)' AND school='\(favorite.school)' AND department ='\(favorite.department)';"
        do {
            for _ in try db.prepare(sql) {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    static func save(favorite: Favorite) {
        let db: Connection = UserDatabase.getDatabaseConnection()!
        let sql = "INSERT INTO Favorite VALUES('\(favorite.examine)','\(favorite.school)','\(favorite.department)');"
        do {
            try db.execute(sql)
        } catch {
            print(error)
        }
    }
    
    static func delete(favorite: Favorite) {
        let db: Connection = UserDatabase.getDatabaseConnection()!
        let sql = "DELETE FROM Favorite WHERE examine='\(favorite.examine)' AND school='\(favorite.school)' AND department ='\(favorite.department)';"
        do {
            try db.execute(sql)
        } catch {
            print(error)
        }
    }
    
    static func saveOrDelete(favorite: Favorite) {
        if (Favorite.isFavoriteExist(favorite: favorite)) {
            Favorite.delete(favorite: favorite)
        } else {
            Favorite.save(favorite: favorite)
        }
    }
    
    static func findByExamine(examine: String) -> [Favorite] {
        var favoriteList: [Favorite] = []
        let db: Connection = UserDatabase.getDatabaseConnection()!
        let sql = "SELECT * FROM Favorite WHERE examine='\(examine)';"
        do {
            for row in try db.prepare(sql) {
                favoriteList.append(Favorite.dbRowToFavorite(row: row))
            }
            return favoriteList
        } catch {
            print(error)
        }
        return []
    }
    
    static func findAll() {
        let db: Connection = UserDatabase.getDatabaseConnection()!
        let sql = "SELECT * FROM Favorite;"
        do {
            for row in try db.prepare(sql) {
                print(row)
            }
        } catch {
            print(error)
        }
    }
}
