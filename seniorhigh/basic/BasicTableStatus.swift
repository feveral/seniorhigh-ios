//
//  BasicTableStatus.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/15.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit

enum BasicSchoolDepartmentStatus {
    case school
    case department
}

class BasicTableStatus {
    
    private var firstYear = Config.Application.basicFirstYear
    private var secondYear = Config.Application.basicSecondYear
    private var schoolDepartmentStatus = BasicSchoolDepartmentStatus.school
    private var schoolOrDepartmentList: [String] = []
    private var choosedSchool: String = ""
    
    init() {
        switchToSchool()
    }
    
    public func getSchoolDepartmentStatus() -> BasicSchoolDepartmentStatus {
        return schoolDepartmentStatus
    }
    
    public func switchToSchool() {
        schoolOrDepartmentList = BasicGrade.findAllSchools(year: firstYear)
        schoolDepartmentStatus = .school
    }

    public func clickCell(viewController: UIViewController, indexPath: IndexPath) {
        if (schoolDepartmentStatus == .school) {
            schoolDepartmentStatus = .department
            choosedSchool = schoolOrDepartmentList[indexPath.row]
            schoolOrDepartmentList = BasicGrade.findDepartments(year: firstYear, school: choosedSchool)
        } else if (schoolDepartmentStatus == .department) {
            let dialog = BasicDialog.buildDialog(school: choosedSchool, department: schoolOrDepartmentList[indexPath.row])
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        }
    }
    
    public func cellCount() -> Int {
        return schoolOrDepartmentList.count
    }
    
    public func buildCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = schoolOrDepartmentList[indexPath.row]
        return cell
    }
}
