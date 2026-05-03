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
        
        // Handle nullable subject/grade pairs
        if let subject1 = row[4] as? String, let grade1 = row[5] as? Double {
            subjectGrade.add(subject: subject1, grade: grade1)
        }
        if let subject2 = row[6] as? String, let grade2 = row[7] as? Double {
            subjectGrade.add(subject: subject2, grade: grade2)
        }
        if let subject3 = row[8] as? String, let grade3 = row[9] as? Double {
            subjectGrade.add(subject: subject3, grade: grade3)
        }
        if let subject4 = row[10] as? String, let grade4 = row[11] as? Double {
            subjectGrade.add(subject: subject4, grade: grade4)
        }
        if let subject5 = row[12] as? String, let grade5 = row[13] as? Double {
            subjectGrade.add(subject: subject5, grade: grade5)
        }
        if let subject6 = row[14] as? String, let grade6 = row[15] as? Double {
            subjectGrade.add(subject: subject6, grade: grade6)
        }
        
        return BasicGrade(
            year: String(row[0]! as! Int64),
            school: row[1]! as! String,
            department: row[2]! as! String, 
            subjectGrade: subjectGrade, 
            people: Int(row[3]! as! Int64)
        )
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
    
    static func findDepartmentGrades(year: String, school: String) -> [BasicGrade] {
        do {
            var grades: [BasicGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Basic where year='\(year)' AND school='\(school)'"
            for row in try db.prepare(sql) {
                grades.append(BasicGrade.dbRowToBasicGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }

    private static let IS_FIRST_GROUP_DEPT = "(department LIKE '%金融%' OR department LIKE '%經濟%' OR department LIKE '%財務%' OR department LIKE '%會計%')"
    private static let HAS_MATH_A = "(firstOrder LIKE '%數A%' OR secondOrder LIKE '%數A%' OR thirdOrder LIKE '%數A%' OR fourthOrder LIKE '%數A%' OR fifthOrder LIKE '%數A%' OR sixthOrder LIKE '%數A%')"
    private static let HAS_MATH_B = "(firstOrder LIKE '%數B%' OR secondOrder LIKE '%數B%' OR thirdOrder LIKE '%數B%' OR fourthOrder LIKE '%數B%' OR fifthOrder LIKE '%數B%' OR sixthOrder LIKE '%數B%')"
    private static let HAS_SOCIAL = "(firstOrder LIKE '%社%' OR secondOrder LIKE '%社%' OR thirdOrder LIKE '%社%' OR fourthOrder LIKE '%社%' OR fifthOrder LIKE '%社%' OR sixthOrder LIKE '%社%')"
    private static let HAS_NATURE = "(firstOrder LIKE '%自然%' OR secondOrder LIKE '%自然%' OR thirdOrder LIKE '%自然%' OR fourthOrder LIKE '%自然%' OR fifthOrder LIKE '%自然%' OR sixthOrder LIKE '%自然%')"

    static func findFirstGroup(year: String) -> [BasicGrade] {
        do {
            var grades: [BasicGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Basic where year='\(year)' AND (\(IS_FIRST_GROUP_DEPT) OR \(HAS_MATH_B) OR (NOT \(HAS_MATH_A) AND \(HAS_SOCIAL)))"
            for row in try db.prepare(sql) {
                grades.append(BasicGrade.dbRowToBasicGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }

    static func findSecondGroup(year: String) -> [BasicGrade] {
        do {
            var grades: [BasicGrade] = []
            let db: Connection = GradeDatabase.getDatabaseConnection()!
            let sql = "SELECT * from Basic where year='\(year)' AND NOT \(IS_FIRST_GROUP_DEPT) AND (\(HAS_MATH_A) OR (NOT \(HAS_MATH_B) AND \(HAS_NATURE)))"
            for row in try db.prepare(sql) {
                grades.append(BasicGrade.dbRowToBasicGrade(row: row))
            }
            return grades
        } catch {
            print(error)
        }
        return []
    }

    static func sortHighToLow(grades: [BasicGrade]) -> [BasicGrade] {
        return grades.sorted { $0.getAverageLastGrade() > $1.getAverageLastGrade() }
    }

    // MARK: - Grade display helpers

    private static func isNormalSubject(_ subject: String) -> Bool {
        return subject.contains("國") || subject.contains("英") || subject.contains("數") ||
               subject.contains("社") || subject.contains("自")
    }

    private static func countSubjectsInOrder(_ order: String) -> Int {
        var count = 0
        if order.contains("國") { count += 1 }
        if order.contains("英") { count += 1 }
        if order.contains("數") { count += 1 }
        if order.contains("社") { count += 1 }
        if order.contains("自") { count += 1 }
        return max(count, 1)
    }

    func getLastGrade() -> Double {
        let sg = subjectGrade
        for i in stride(from: sg.order, through: 1, by: -1) {
            let subject = sg.getSubject(order: i)
            let grade = sg.getGrade(order: i)
            if grade > 0 && BasicGrade.isNormalSubject(subject) {
                return grade
            }
        }
        return 0
    }

    func getLastOrder() -> String {
        let sg = subjectGrade
        for i in stride(from: sg.order, through: 1, by: -1) {
            let subject = sg.getSubject(order: i)
            let grade = sg.getGrade(order: i)
            if grade > 0 && BasicGrade.isNormalSubject(subject) {
                return subject
            }
        }
        return ""
    }

    func getAverageLastGrade() -> Double {
        let sg = subjectGrade
        if sg.order == 0 { return 0 }
        var sum: Double = 0
        var count = 0
        for i in 1...sg.order {
            let subject = sg.getSubject(order: i)
            let grade = sg.getGrade(order: i)
            if grade > 0 && BasicGrade.isNormalSubject(subject) {
                sum += grade / Double(BasicGrade.countSubjectsInOrder(subject))
                count += 1
            }
        }
        if count == 0 { return 0 }
        return sum / Double(count)
    }

    func getLastGradeString() -> String {
        let lastOrder = getLastOrder().replacingOccurrences(of: "+", with: "")
        let lastGrade = getLastGrade()
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        let formatted = nf.string(from: NSNumber(value: lastGrade)) ?? "0"
        return "\(lastOrder)\n\(formatted)"
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
    private var subjectGrades: [Int:(String, Double)] = [:]
    
    public var order: Int{
        return gradeOrder
    }
    
    func add(subject: String, grade: Double) {
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
    
    func getGrade(order: Int) -> Double {
        if (gradeOrder >= order && order > 0) {
            return subjectGrades[order]!.1
        }
        return 0
    }
}

