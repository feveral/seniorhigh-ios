//
//  DesignatedGrade.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/9.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import SQLite

class DesignatedGrade {
    private var _isEmpty: Bool = true
    var year: String = ""
    var school: String = ""
    var department: String = ""
    var subjectWeight: DesignatedSubjectWeight = DesignatedSubjectWeight()
    var grade: Double = 0.0
    var people: Int = 0
    
    var weightedGrade: Double {
        return grade / subjectWeight.totalWeight
    }
    
    var isEmpty: Bool {
        return _isEmpty
    }
    
    init() {
        
    }
    
    init(year: String, school: String, department: String, subjectWeight: DesignatedSubjectWeight, grade: Double, people: Int) {
        self.year = year
        self.school = school
        self.department = department
        self.subjectWeight = subjectWeight
        self.grade = grade
        self.people = people
        self._isEmpty = false
    }
    
    static func dbRowToDesignatedGrade(row: [Binding?]) -> DesignatedGrade {
        let subjectWeight = DesignatedSubjectWeight()
        
        // Handle nullable weights with new English column names
        if let chinese = row[4] as? Double { subjectWeight.add(subject: "國", weight: Double(chinese)) }
        if let english = row[5] as? Double { subjectWeight.add(subject: "英", weight: Double(english)) }
        if let mathAdvance = row[6] as? Double { subjectWeight.add(subject: "數甲", weight: Double(mathAdvance)) }
        if let mathBasic = row[7] as? Double { subjectWeight.add(subject: "數乙", weight: Double(mathBasic)) }
        if let mathA = row[8] as? Double { subjectWeight.add(subject: "數A", weight: Double(mathA)) }
        if let mathB = row[9] as? Double { subjectWeight.add(subject: "數B", weight: Double(mathB)) }
        if let physical = row[10] as? Double { subjectWeight.add(subject: "物", weight: Double(physical)) }
        if let chemistry = row[11] as? Double { subjectWeight.add(subject: "化", weight: Double(chemistry)) }
        if let biological = row[12] as? Double { subjectWeight.add(subject: "生", weight: Double(biological)) }
        if let geography = row[13] as? Double { subjectWeight.add(subject: "地", weight: Double(geography)) }
        if let history = row[14] as? Double { subjectWeight.add(subject: "歷", weight: Double(history)) }
        if let citizen = row[15] as? Double { subjectWeight.add(subject: "公", weight: Double(citizen)) }
        if let society = row[16] as? Double { subjectWeight.add(subject: "社", weight: Double(society)) }
        if let nature = row[17] as? Double { subjectWeight.add(subject: "自", weight: Double(nature)) }
        if let skill = row[18] as? Double { subjectWeight.add(subject: "術", weight: Double(skill)) }
        
        return DesignatedGrade(
            year: String(row[0]! as! Int64), 
            school: row[1]! as! String, 
            department: row[2]! as! String, 
            subjectWeight: subjectWeight, 
            grade: DBUtils.toDouble(row[19]),
            people: Int(row[3]! as! Int64)
        )
    }
    
    static func sortHighToLow(grades:[DesignatedGrade]) -> [DesignatedGrade] {
        return grades.sorted(by: {$0.weightedGrade > $1.weightedGrade})
    }
    
    static func findAllSchools(year: String) -> [String] {
        do {
            var schools: Array<String> = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT DISTINCT school from Designated where year='\(year)'"
            for school in try db.prepare(sql) {
                schools.append(school[0]! as! String)
            }
            return schools
        } catch {
            print(error)
        }
        return []
    }
    
    static func findDepartments(year: String, school: String) -> [String]{
        do {
            var departments: [String] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT department from Designated where year='\(year)' AND school='\(school)'"
            for department in try db.prepare(sql) {
                departments.append(department[0]! as! String)
            }
            return departments
        } catch {
            print(error)
        }
        return []
    }
    
    static func find(year: String, school: String, department: String) -> DesignatedGrade {
        do {
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Designated where year='\(year)' AND school='\(school)' AND department='\(department)'"
            for row in try db.prepare(sql) {
                return DesignatedGrade.dbRowToDesignatedGrade(row: row)
            }
        } catch {
            print(error)
        }
        return DesignatedGrade()
    }
    
    static func findByKeyword(year: String, keyWord: String) -> [DesignatedGrade] {
        do {
            if keyWord.count == 0 {
                return []
            }
            var grades: [DesignatedGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            var keyWordPattern = "%";
            for i in 0...keyWord.count-1 {
                let startIndex = keyWord.startIndex
                keyWordPattern += (String(keyWord[keyWord.index(startIndex, offsetBy: i)]) + "%");
            }
            let sql = "SELECT * from Designated where year='\(year)' AND (school LIKE '\(keyWordPattern)' OR department LIKE '\(keyWordPattern)');"
            for row in try db.prepare(sql) {
                grades.append(DesignatedGrade.dbRowToDesignatedGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
    
    static func findFirstGroup(year: String) -> [DesignatedGrade]{
        do {
            var grades: [DesignatedGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Designated where year='\(year)' AND mathB>0"
            for row in try db.prepare(sql) {
                grades.append(DesignatedGrade.dbRowToDesignatedGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
    
    static func findSecondGroup(year: String) -> [DesignatedGrade] {
        do {
            var grades: [DesignatedGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Designated where year='\(year)' AND (mathA>0 OR mathAdvance>0) AND biological IS NULL"
            for row in try db.prepare(sql) {
                grades.append(DesignatedGrade.dbRowToDesignatedGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
    
    static func findThirdGroup(year: String) -> [DesignatedGrade] {
        do {
            var grades: [DesignatedGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Designated where year='\(year)' AND biological>0"
            for row in try db.prepare(sql) {
                grades.append(DesignatedGrade.dbRowToDesignatedGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }
    
}

class DesignatedSubjectWeight {
    var subjectWeights = Dictionary<String, Double>()

    var totalWeight: Double {
        var total: Double = 0.0
        for (_, weight) in subjectWeights {
            total += weight
        }
        return total
    }

    func add(subject: String, weight: Double) {
        if (weight != 0) {
            subjectWeights[subject] = weight
        }
    }
}
