//
//  FavoriteTableStatus.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/9/4.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit


enum FavoriteExamineStatus {
    case designated
    case basic
    case unify
}

class FavoriteTableStatus {
    
    var favoriteList: [Favorite] = []
    var examineStatus: FavoriteExamineStatus = .designated
    
    init() {
        switchToDesignated()
    }
    
    public func refresh() {
        if (examineStatus == .designated) {
            favoriteList = Favorite.findByExamine(examine: Config.Text.DESIGNATED)
        } else if (examineStatus == .basic) {
            favoriteList = Favorite.findByExamine(examine: Config.Text.BASIC)
        } else if (examineStatus == .unify) {
            favoriteList = Favorite.findByExamine(examine: Config.Text.UNIFY)
        }
    }
    
    public func switchToDesignated() {
        examineStatus = .designated
        refresh()
    }
    
    public func switchToBasic() {
        examineStatus = .basic
        refresh()
    }
    
    public func switchToUnify() {
        examineStatus = .unify
        refresh()
    }
    
    public func cellCount() -> Int {
        return favoriteList.count
    }
    
    public func buildCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell") as! GradeTableViewCell
        cell.schoolLabel?.text = favoriteList[indexPath.row].school
        cell.departmentLabel?.text = favoriteList[indexPath.row].department
        cell.gradeLabel?.text = ""
        return cell
    }
    
    public func clickCell(viewController: UIViewController, indexPath: IndexPath) {
        if (examineStatus == .designated) {
            let dialog = DesignatedDialog.buildDialog(school: favoriteList[indexPath.row].school, department: favoriteList[indexPath.row].department)
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        } else if (examineStatus == .basic) {
            let dialog = BasicDialog.buildDialog(school: favoriteList[indexPath.row].school, department: favoriteList[indexPath.row].department)
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        } else if (examineStatus == .unify) {
            let dialog = UnifyDialog.buildDialog(school: favoriteList[indexPath.row].school, department: favoriteList[indexPath.row].department)
            dialog.transitioningDelegate = (viewController as! UIViewControllerTransitioningDelegate)
            viewController.present(dialog, animated: true, completion: nil)
        }
    }
}
