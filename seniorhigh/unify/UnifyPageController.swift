//
//  UnifyPageController.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/17.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class UnifyPageController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    //MARK: Properties
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchButtonScrollView: UIScrollView!
    @IBOutlet weak var switchToAllSchoolButton: UIButton!
    @IBOutlet weak var switchToGroup1Button: UIButton!
    @IBOutlet weak var switchToGroup2Button: UIButton!
    @IBOutlet weak var switchToGroup3Button: UIButton!
    @IBOutlet weak var switchToGroup4Button: UIButton!
    @IBOutlet weak var switchToGroup5Button: UIButton!
    @IBOutlet weak var switchToGroup6Button: UIButton!
    @IBOutlet weak var switchToGroup7Button: UIButton!
    @IBOutlet weak var switchToGroup8Button: UIButton!
    @IBOutlet weak var switchToGroup9Button: UIButton!
    @IBOutlet weak var switchToGroup10Button: UIButton!
    @IBOutlet weak var switchToGroup11Button: UIButton!
    @IBOutlet weak var switchToGroup12Button: UIButton!
    @IBOutlet weak var switchToGroup13Button: UIButton!
    @IBOutlet weak var switchToGroup14Button: UIButton!
    @IBOutlet weak var switchToGroup15Button: UIButton!
    @IBOutlet weak var switchToGroup16Button: UIButton!
    @IBOutlet weak var switchToGroup17Button: UIButton!
    @IBOutlet weak var switchToGroup18Button: UIButton!
    @IBOutlet weak var switchToGroup19Button: UIButton!
    @IBOutlet weak var switchToGroup20Button: UIButton!
    
    var unifyGroupButton: UnifyGroupButton!
    var tableStatus = UnifyTableStatus()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStatus.cellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableStatus.buildCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableStatus.getSchoolDepartmentStatus() == .school && tableStatus.getGroupStatus() == .schoolDepartment) {
            reloadTable()
        }
        tableStatus.clickCell(viewController: self, indexPath: indexPath)
        setBackButtonVisibility()
    }
    
    func reloadTable() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        UIView.transition(with: tableView,
                          duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
        setBackButtonVisibility()
        tableView.backgroundColor = UIColor.white
    }
    
    private func setBackButtonVisibility() {
        if (tableStatus.getGroupStatus() == .schoolDepartment
            && tableStatus.getSchoolDepartmentStatus() == .department) {
            backButton.isEnabled = true
            backButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            backButton.isEnabled = false
            backButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    override func viewDidLoad() {
        let groupButtons = [switchToGroup1Button, switchToGroup2Button, switchToGroup3Button, switchToGroup4Button, switchToGroup5Button, switchToGroup6Button, switchToGroup7Button, switchToGroup8Button, switchToGroup9Button, switchToGroup10Button, switchToGroup11Button, switchToGroup12Button, switchToGroup13Button, switchToGroup14Button, switchToGroup15Button, switchToGroup16Button, switchToGroup17Button, switchToGroup18Button, switchToGroup19Button, switchToGroup20Button]
        unifyGroupButton = UnifyGroupButton(switchToAllSchoolButton: switchToAllSchoolButton, switchToGroupButtons: groupButtons as! [UIButton])
        initialAd()
        setBackButtonVisibility()
    }
    
    //MARK: Actions
    @IBAction func backPressed(_ sender: Any) {
        if (tableStatus.getGroupStatus() == .schoolDepartment) {
            tableStatus.switchToSchool()
            reloadTable()
        }
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {

        if (unifyGroupButton.switchToRight()) {
            switchButtonScrollView.setContentOffset(CGPoint(x: unifyGroupButton.currentIndex * 70, y: 0), animated: true)
            if (unifyGroupButton.currentIndex == 0) {
                tableStatus.switchToSchool()
            } else {
                tableStatus.switchToGroup(groupNumber: unifyGroupButton.currentIndex)
            }
            reloadTable()
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if (unifyGroupButton.switchToLeft()) {
            switchButtonScrollView.setContentOffset(CGPoint(x: unifyGroupButton.currentIndex * 70, y: 0), animated: true)
            if (unifyGroupButton.currentIndex == 0) {
                tableStatus.switchToSchool()
            } else {
                tableStatus.switchToGroup(groupNumber: unifyGroupButton.currentIndex)
            }
            reloadTable()
        }
    }
    
    @IBAction func switchToAllSchool(_ sender: Any) {
        unifyGroupButton.switchToAllSchool()
        tableStatus.switchToSchool()
        reloadTable()
    }
    @IBAction func switchToGroup1(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 1)
        tableStatus.switchToGroup(groupNumber: 1)
        reloadTable()
    }
    @IBAction func switchToGroup2(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 2)
        tableStatus.switchToGroup(groupNumber: 2)
        reloadTable()
    }
    @IBAction func switchToGroup3(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 3)
        tableStatus.switchToGroup(groupNumber: 3)
        reloadTable()
    }
    @IBAction func switchToGroup4(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 4)
        tableStatus.switchToGroup(groupNumber: 4)
        reloadTable()
    }
    @IBAction func switchToGroup5(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 5)
        tableStatus.switchToGroup(groupNumber: 5)
        reloadTable()
    }
    @IBAction func switchToGroup6(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 6)
        tableStatus.switchToGroup(groupNumber: 6)
        reloadTable()
    }
    @IBAction func switchToGroup7(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 7)
        tableStatus.switchToGroup(groupNumber: 7)
        reloadTable()
    }
    @IBAction func switchToGroup8(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 8)
        tableStatus.switchToGroup(groupNumber: 8)
        reloadTable()
    }
    @IBAction func switchToGroup9(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 9)
        tableStatus.switchToGroup(groupNumber: 9)
        reloadTable()
    }
    @IBAction func switchToGroup10(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 10)
        tableStatus.switchToGroup(groupNumber: 10)
        reloadTable()
    }
    @IBAction func switchToGroup11(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 11)
        tableStatus.switchToGroup(groupNumber: 11)
        reloadTable()
    }
    @IBAction func switchToGroup12(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 12)
        tableStatus.switchToGroup(groupNumber: 12)
        reloadTable()
    }
    @IBAction func switchToGroup13(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 13)
        tableStatus.switchToGroup(groupNumber: 13)
        reloadTable()
    }
    @IBAction func switchToGroup14(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 14)
        tableStatus.switchToGroup(groupNumber: 14)
        reloadTable()
    }
    @IBAction func switchToGroup15(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 15)
        tableStatus.switchToGroup(groupNumber: 15)
        reloadTable()
    }
    @IBAction func switchToGroup16(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 16)
        tableStatus.switchToGroup(groupNumber: 16)
        reloadTable()
    }
    @IBAction func switchToGroup17(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 17)
        tableStatus.switchToGroup(groupNumber: 17)
        reloadTable()
    }
    @IBAction func switchToGroup18(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 18)
        tableStatus.switchToGroup(groupNumber: 18)
        reloadTable()
    }
    @IBAction func switchToGroup19(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 19)
        tableStatus.switchToGroup(groupNumber: 19)
        reloadTable()
    }
    @IBAction func switchToGroup20(_ sender: Any) {
        unifyGroupButton.switchToGroup(groupNumber: 20)
        tableStatus.switchToGroup(groupNumber: 20)
        reloadTable()
    }
    
    func initialAd() {
        let bannerView: GADBannerView = AdManager.buildBannerView(viewController: self)
        AdManager.addBottomBannerViewToView(view: view, bannerView: bannerView)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}
