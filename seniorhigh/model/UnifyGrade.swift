//
//  UnifyGrade.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/17.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import SQLite


class UnifyGrade {
    
    private var _isEmpty: Bool = true
    var year: String = ""
    var school: String = ""
    var department: String = ""
    var groupName = ""
    var grade: Double = 0.0
    
    init() {
        
    }
    
    init(year: String, school: String, department: String, groupName: String, grade: Double) {
        self.year = year
        self.school = school
        self.department = department
        self.groupName = groupName
        self.grade = grade
        self._isEmpty = false
    }
    
    var isEmpty: Bool {
        return _isEmpty
    }
    
    static func dbRowToUnifyGrade(row: [Binding?]) -> UnifyGrade {
        return UnifyGrade(
            year: String(row[0]! as! Int64),
            school: row[1]! as! String,
            department: row[2]! as! String, 
            groupName: row[4]! as! String, 
            grade: DBUtils.toDouble(row[3])
        )
    }
    
    static func findAllSchools(year: String) -> [String] {
        do {
            var schools: Array<String> = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT DISTINCT school from Unify where year='\(year)'"
            for school in try db.prepare(sql) {
                schools.append(school[0]! as! String)
            }
            return schools
        } catch {
            print(error)
        }
        return []
    }
    
    static func findDepartments(year: String, school: String) -> [String] {
        do {
            var departments: [String] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT department from Unify where year='\(year)' AND school='\(school)'"
            for department in try db.prepare(sql) {
                departments.append(department[0]! as! String)
            }
            return departments
        } catch {
            print(error)
        }
        return []
    }
    
    static func find(year: String, school: String, department: String) -> [UnifyGrade] {
        do {
            var grades: [UnifyGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Unify where year='\(year)' AND school='\(school)' AND department='\(department)'"
            for row in try db.prepare(sql) {
                grades.append(UnifyGrade.dbRowToUnifyGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
    
    static func find(year: String, groupNumber: Int) -> [UnifyGrade] {
        do {
            let departmentGroup = UnifyGradeUtils.groupNumberToGroupName(groupNumber: groupNumber)
            var grades: [UnifyGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Unify where year='\(year)' AND departmentGroup='\(departmentGroup)'"
            for row in try db.prepare(sql) {
                grades.append(UnifyGrade.dbRowToUnifyGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
    
    static func findByKeyword(year: String, keyWord: String) -> [UnifyGrade] {
        do {
            if keyWord.count == 0 {
                return []
            }
            var grades: [UnifyGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            var keyWordPattern = "%";
            for i in 0...keyWord.count-1 {
                let startIndex = keyWord.startIndex
                keyWordPattern += (String(keyWord[keyWord.index(startIndex, offsetBy: i)]) + "%");
            }
            let sql = "SELECT * from Unify where year='\(year)' AND (school LIKE '\(keyWordPattern)' OR department LIKE '\(keyWordPattern)');"
            for row in try db.prepare(sql) {
                grades.append(UnifyGrade.dbRowToUnifyGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
    
    static func sortHighToLow(grades:[UnifyGrade]) -> [UnifyGrade] {
        return grades.sorted(by: {$0.grade > $1.grade})
    }
}

class UnifyGradeUtils {
    static func groupNumberToGroupName(groupNumber: Int) -> String{
        if (groupNumber == 1) {
            return "機械"
        } else if (groupNumber == 2) {
            return "動機"
        } else if (groupNumber == 3) {
            return "電機"
        } else if (groupNumber == 4) {
            return "資電"
        } else if (groupNumber == 5) {
            return "化工"
        } else if (groupNumber == 6) {
            return "土木"
        } else if (groupNumber == 7) {
            return "設計"
        } else if (groupNumber == 8) {
            return "工管"
        } else if (groupNumber == 9) {
            return "商管"
        } else if (groupNumber == 10) {
            return "衛護"
        } else if (groupNumber == 11) {
            return "食品"
        } else if (groupNumber == 12) {
            return "幼保"
        } else if (groupNumber == 13) {
            return "生活"
        } else if (groupNumber == 14) {
            return "農業"
        } else if (groupNumber == 15) {
            return "英語"
        } else if (groupNumber == 16) {
            return "日語"
        } else if (groupNumber == 17) {
            return "餐旅"
        } else if (groupNumber == 18) {
            return "海事"
        } else if (groupNumber == 19) {
            return "水產"
        } else if (groupNumber == 20) {
            return "藝影"
        }
        return ""
    }
}
