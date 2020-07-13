//
//  DesignatedSchoolList.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/9.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit

enum DesignatedGroupStatus {
    case schoolDepartment
    case group1
    case group2
    case group3
}

enum DesignatedSchoolDepartmentStatus {
    case school
    case department
}

class DesignatedTableStatus {
    
    private var firstYear = Config.Application.designatedFirstYear
    private var secondYear = Config.Application.designatedSecondYear
    private var schoolDepartmentStatus = DesignatedSchoolDepartmentStatus.school
    private var groupStatus = DesignatedGroupStatus.schoolDepartment
    private var choosedSchool = ""
    private var schoolOrDepartmentList: [String] = []
    private var gradeList: [DesignatedGrade] = []
    
    init() {
        switchToSchool()
    }
    
    public func getGroupStatus() -> DesignatedGroupStatus {
        return groupStatus
    }
    
    public func getSchoolDepartmentStatus() -> DesignatedSchoolDepartmentStatus{
        return schoolDepartmentStatus
    }
    
    public func clickCell(viewController: UIViewController, indexPath: IndexPath) {
        if (groupStatus == .schoolDepartment && schoolDepartmentStatus == .school) {
            choosedSchool = schoolOrDepartmentList[indexPath.row]
            schoolDepartmentStatus = .department
            schoolOrDepartmentList = DesignatedGrade.findDepartments(year: firstYear, school: choosedSchool)
        } else if (groupStatus == .schoolDepartment && schoolDepartmentStatus == .department) {
            let dialog = DesignatedDialog.buildDialog(school: choosedSchool, department: schoolOrDepartmentList[indexPath.row])
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        } else if (groupStatus != .schoolDepartment) {
            let dialog = DesignatedDialog.buildDialog(school: gradeList[indexPath.row].school, department: gradeList[indexPath.row].department)
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        }
    }
    
    public func switchToSchool() {
        schoolDepartmentStatus = .school
        groupStatus = .schoolDepartment
        schoolOrDepartmentList = DesignatedGrade.findAllSchools(year: firstYear)
    }
    
    public func switchToGroup(groupNumber: Int) {
        if (groupNumber == 1) {
            groupStatus = .group1
            gradeList = DesignatedGrade.findFirstGroup(year: firstYear)
            gradeList = DesignatedGrade.sortHighToLow(grades: gradeList)
        } else if (groupNumber == 2) {
            groupStatus = .group2
            gradeList = DesignatedGrade.findSecondGroup(year: firstYear)
            gradeList = DesignatedGrade.sortHighToLow(grades: gradeList)
        } else if (groupNumber == 3) {
            groupStatus = .group3
            gradeList = DesignatedGrade.findThirdGroup(year: firstYear)
            gradeList = DesignatedGrade.sortHighToLow(grades: gradeList)
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
            cell.gradeLabel?.text = String(format: "%.2f", gradeList[indexPath.row].weightedGrade)
            return cell
        }
    }
}
