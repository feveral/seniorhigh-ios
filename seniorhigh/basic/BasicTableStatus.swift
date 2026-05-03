//
//  BasicTableStatus.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/15.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit

enum BasicGroupStatus {
    case schoolDepartment
    case group1
    case group2
}

enum BasicSchoolDepartmentStatus {
    case school
    case department
}

class BasicTableStatus {

    private var firstYear = Config.Application.basicFirstYear
    private var secondYear = Config.Application.basicSecondYear
    private var schoolDepartmentStatus = BasicSchoolDepartmentStatus.school
    private var groupStatus = BasicGroupStatus.schoolDepartment
    private var choosedSchool: String = ""
    private var schoolList: [String] = []
    private var departmentGradeList: [BasicGrade] = []
    private var gradeList: [BasicGrade] = []

    init() {
        switchToSchool()
    }

    public func getGroupStatus() -> BasicGroupStatus {
        return groupStatus
    }

    public func getSchoolDepartmentStatus() -> BasicSchoolDepartmentStatus {
        return schoolDepartmentStatus
    }

    public func switchToSchool() {
        schoolList = BasicGrade.findAllSchools(year: firstYear)
        schoolDepartmentStatus = .school
        groupStatus = .schoolDepartment
    }

    public func switchToGroup(groupNumber: Int) {
        if groupNumber == 1 {
            groupStatus = .group1
            gradeList = BasicGrade.sortHighToLow(grades: BasicGrade.findFirstGroup(year: firstYear))
        } else if groupNumber == 2 {
            groupStatus = .group2
            gradeList = BasicGrade.sortHighToLow(grades: BasicGrade.findSecondGroup(year: firstYear))
        }
    }

    public func clickCell(viewController: UIViewController, indexPath: IndexPath) {
        if groupStatus != .schoolDepartment {
            let dialog = BasicDialog.buildDialog(school: gradeList[indexPath.row].school, department: gradeList[indexPath.row].department)
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        } else if schoolDepartmentStatus == .school {
            choosedSchool = schoolList[indexPath.row]
            schoolDepartmentStatus = .department
            departmentGradeList = BasicGrade.findDepartmentGrades(year: firstYear, school: choosedSchool)
        } else if schoolDepartmentStatus == .department {
            let dialog = BasicDialog.buildDialog(school: choosedSchool, department: departmentGradeList[indexPath.row].department)
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        }
    }

    public func cellCount() -> Int {
        if groupStatus != .schoolDepartment {
            return gradeList.count
        }
        if schoolDepartmentStatus == .department {
            return departmentGradeList.count
        }
        return schoolList.count
    }

    public func buildCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        if groupStatus != .schoolDepartment {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! GradeTableViewCell
            cell.schoolLabel?.text = gradeList[indexPath.row].school
            cell.departmentLabel?.text = gradeList[indexPath.row].department
            cell.gradeLabel?.text = gradeList[indexPath.row].getLastGradeString()
            return cell
        } else if schoolDepartmentStatus == .department {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! GradeTableViewCell
            cell.schoolLabel?.text = departmentGradeList[indexPath.row].department
            cell.departmentLabel?.isHidden = true
            cell.gradeLabel?.text = departmentGradeList[indexPath.row].getLastGradeString()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! SchoolListTableViewCell
            cell.configure(title: schoolList[indexPath.row])
            return cell
        }
    }
}
