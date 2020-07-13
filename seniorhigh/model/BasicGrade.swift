//
//  BasicGrade.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/15.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import SQLite

class BasicGrade {
    private var _isEmpty: Bool = true
    var year: String = ""
    var school: String = ""
    var department: String = ""
    var subjectGrade = BasicSubjectGrade()
    var people: Int = 0
    
    init() {
        
    }
    
    init(year: String, school: String, department: String, subjectGrade: BasicSubjectGrade, people: Int) {
        self.year = year
        self.school = school
        self.department = department
        self.subjectGrade = subjectGrade
        self.people = people
        self._isEmpty = false
    }
    
    var isEmpty: Bool {
        return _isEmpty
    }
    
    static func dbRowToBasicGrade(row: [Binding?]) -> BasicGrade {
        let subjectGrade = BasicSubjectGrade()
        subjectGrade.add(subject: row[4]! as! String, grade: Int(row[5]! as! Int64))
        subjectGrade.add(subject: row[6]! as! String, grade: Int(row[7]! as! Int64))
        subjectGrade.add(subject: row[8]! as! String, grade: Int(row[9]! as! Int64))
        subjectGrade.add(subject: row[10]! as! String, grade: Int(row[11]! as! Int64))
        subjectGrade.add(subject: row[12]! as! String, grade: Int(row[13]! as! Int64))
        return BasicGrade(year: row[1]! as! String, school: row[2]! as! String, department: row[3]! as! String, subjectGrade: subjectGrade, people: Int(row[14]! as! Int64))
    }
    
    static func findAllSchools(year: String) -> [String] {
        do {
            var schools: Array<String> = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT DISTINCT school from Basic where year='\(year)'"
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
            let sql = "SELECT department from Basic where year='\(year)' AND school='\(school)'"
            for department in try db.prepare(sql) {
                departments.append(department[0]! as! String)
            }
            return departments
        } catch {
            print(error)
        }
        return []
    }
    
    static func find(year: String, school: String, department: String) -> BasicGrade {
        do {
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Basic where year='\(year)' AND school='\(school)' AND department='\(department)'"
            for row in try db.prepare(sql) {
                return BasicGrade.dbRowToBasicGrade(row: row)
            }
        } catch {
            print(error)
        }
        return BasicGrade()
    }
    
    static func findByKeyword(year: String, keyWord: String) -> [BasicGrade] {
        do {
            if keyWord.count == 0 {
                return []
            }
            var grades: [BasicGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            var keyWordPattern = "%";
            for i in 0...keyWord.count-1 {
                let startIndex = keyWord.startIndex
                keyWordPattern += (String(keyWord[keyWord.index(startIndex, offsetBy: i)]) + "%");
            }
            let sql = "SELECT * from Basic where year='\(year)' AND (school LIKE '\(keyWordPattern)' OR department LIKE '\(keyWordPattern)');"
            for row in try db.prepare(sql) {
                grades.append(BasicGrade.dbRowToBasicGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
}

class BasicSubjectGrade {
    
    var gradeOrder = 0
    private var subjectGrades: [Int:(String, Int)] = [:]
    
    public var order: Int{
        return gradeOrder
    }
    
    func add(subject: String, grade: Int) {
        if (subject != "") {
            gradeOrder = gradeOrder + 1
            let t = (subject, grade)
            subjectGrades[gradeOrder] = t
        }
    }
    
    func getSubject(order: Int) -> String {
        if (gradeOrder >= order && order > 0) {
            return subjectGrades[order]!.0
        }
        return ""
    }
    
    func getGrade(order: Int) -> Int {
        if (gradeOrder >= order && order > 0) {
            return subjectGrades[order]!.1
        }
        return 0
    }
}

