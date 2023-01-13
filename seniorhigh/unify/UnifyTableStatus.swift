//
//  UnifyTableStatus.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/17.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit


enum UnifyGroupStatus {
    case schoolDepartment
    case group1
    case group2
    case group3
    case group4
    case group5
    case group6
    case group7
    case group8
    case group9
    case group10
    case group11
    case group12
    case group13
    case group14
    case group15
    case group16
    case group17
    case group18
    case group19
    case group20
}

enum UnifySchoolDepartmentStatus {
    case school
    case department
}


class UnifyTableStatus {
    
    private var firstYear = Config.Application.unifyFirstYear
    private var secondYear = Config.Application.unifySecondYear
    private var groupStatus = UnifyGroupStatus.schoolDepartment
    private var schoolDepartmentStatus = UnifySchoolDepartmentStatus.school
    private var choosedSchool = ""
    private var schoolOrDepartmentList: [String] = []
    private var gradeList: [UnifyGrade] = []
    
    init() {
        switchToSchool()
    }
    
    public func getGroupStatus() -> UnifyGroupStatus {
        return groupStatus
    }
    
    public func getSchoolDepartmentStatus() -> UnifySchoolDepartmentStatus {
        return schoolDepartmentStatus
    }
    
    public func switchToSchool() {
        schoolDepartmentStatus = .school
        groupStatus = .schoolDepartment
        schoolOrDepartmentList = UnifyGrade.findAllSchools(year: firstYear)
    }
    
    public func switchToGroup(groupNumber: Int) {
        if (groupNumber == 1) {
            groupStatus = .group1
        } else if (groupNumber == 2) {
            groupStatus = .group2
        } else if (groupNumber == 3) {
            groupStatus = .group3
        } else if (groupNumber == 4) {
            groupStatus = .group4
        } else if (groupNumber == 5) {
            groupStatus = .group5
        } else if (groupNumber == 6) {
            groupStatus = .group6
        } else if (groupNumber == 7) {
            groupStatus = .group7
        } else if (groupNumber == 8) {
            groupStatus = .group8
        } else if (groupNumber == 9) {
            groupStatus = .group9
        } else if (groupNumber == 10) {
            groupStatus = .group10
        } else if (groupNumber == 11) {
            groupStatus = .group11
        } else if (groupNumber == 12) {
            groupStatus = .group12
        } else if (groupNumber == 13) {
            groupStatus = .group13
        } else if (groupNumber == 14) {
            groupStatus = .group14
        } else if (groupNumber == 15) {
            groupStatus = .group15
        } else if (groupNumber == 16) {
            groupStatus = .group16
        } else if (groupNumber == 17) {
            groupStatus = .group17
        } else if (groupNumber == 18) {
            groupStatus = .group18
        } else if (groupNumber == 19) {
            groupStatus = .group19
        } else if (groupNumber == 20) {
            groupStatus = .group20
        }
        gradeList = UnifyGrade.find(year: firstYear, groupNumber: groupNumber)
        gradeList = UnifyGrade.sortHighToLow(grades: gradeList)
    }
    
    public func clickCell(viewController: UIViewController, indexPath: IndexPath) {
        if (groupStatus == .schoolDepartment && schoolDepartmentStatus == .school) {
            choosedSchool = schoolOrDepartmentList[indexPath.row]
            schoolDepartmentStatus = .department
            schoolOrDepartmentList = UnifyGrade.findDepartments(year: firstYear, school: choosedSchool)
        } else if (groupStatus == .schoolDepartment && schoolDepartmentStatus == .department) {
            let dialog = UnifyDialog.buildDialog(school: choosedSchool, department: schoolOrDepartmentList[indexPath.row])
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        } else if (groupStatus != .schoolDepartment) {
            let dialog = UnifyDialog.buildDialog(school: gradeList[indexPath.row].school, department: gradeList[indexPath.row].department)
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        }
    }
    
    public func cellCount() -> Int {
        if (groupStatus == .schoolDepartment) {
            return schoolOrDepartmentList.count
        }
        return gradeList.count
    }
    
    public func buildCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        if (groupStatus == .schoolDepartment) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = schoolOrDepartmentList[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! GradeTableViewCell
            cell.schoolLabel?.text = gradeList[indexPath.row].school
            cell.departmentLabel?.text = gradeList[indexPath.row].department
            cell.gradeLabel?.text = String(format: "%.2f", gradeList[indexPath.row].grade)
            return cell
        }
    }
}
