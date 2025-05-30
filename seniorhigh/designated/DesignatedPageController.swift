//
//  ViewController.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/7/19.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DesignatedPageController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    var tableStatus = DesignatedTableStatus()
    var bannerView: BannerView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStatus.cellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableStatus.buildCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableStatus.clickCell(viewController: self, indexPath: indexPath)
        reloadTable()
        setBackButtonVisibility()
    }
    
    //MARK: Properties
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var switchToAllSchoolButton: UIButton!
    @IBOutlet weak var switchToFirstGroupButton: UIButton!
    @IBOutlet weak var switchToSecondGroupButton: UIButton!
    @IBOutlet weak var switchToThirdGroupButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var designatedGroupButton: DesignatedGroupButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designatedGroupButton = DesignatedGroupButton(
            switchToAllSchoolButton: self.switchToAllSchoolButton,
            switchToFirstGroupButton: self.switchToFirstGroupButton,
            switchToSecondGroupButton: self.switchToSecondGroupButton,
            switchToThirdGroupButton: self.switchToThirdGroupButton)
        initialAd()
        setBackButtonVisibility()
        tableView.backgroundColor = UIColor.white
    }
    
    func initialAd() {
        let bannerView: BannerView = AdManager.buildBannerView(viewController: self)
        AdManager.addBottomBannerViewToView(view: view, bannerView: bannerView)
    }
    
    func reloadTable() {
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        UIView.transition(with: tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
        setBackButtonVisibility()
    }
    
    private func setBackButtonVisibility() {
        if (tableStatus.getGroupStatus() == .schoolDepartment
            && tableStatus.getSchoolDepartmentStatus() == .department ) {
            backButton.isEnabled = true
            backButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            backButton.isEnabled = false
            backButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    //MARK: Actions
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if (designatedGroupButton.switchToLeft()) {
            if (designatedGroupButton.currentIndex == 0) {
                tableStatus.switchToSchool()
            } else {
                tableStatus.switchToGroup(groupNumber: designatedGroupButton.currentIndex)
            }
            reloadTable()
        }
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if (designatedGroupButton.switchToRight()) {
            if (designatedGroupButton.currentIndex == 0) {
                tableStatus.switchToSchool()
            } else {
                tableStatus.switchToGroup(groupNumber: designatedGroupButton.currentIndex)
            }
            reloadTable()
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if (tableStatus.getGroupStatus() == .schoolDepartment) {
            tableStatus.switchToSchool()
            reloadTable()
        }
    }
    
    @IBAction func switchToAllSchool(_ sender: Any) {
        designatedGroupButton.switchToAllSchool()
        tableStatus.switchToSchool()
        reloadTable()
    }

    @IBAction func switchToFirstGroup(_ sender: Any) {
        designatedGroupButton.switchToGroup(groupNumber: 1)
        tableStatus.switchToGroup(groupNumber: 1)
        reloadTable()
    }

    @IBAction func switchToSecondGroup(_ sender: Any) {
        designatedGroupButton.switchToGroup(groupNumber: 2)
        tableStatus.switchToGroup(groupNumber: 2)
        reloadTable()
    }

    @IBAction func switchToThirdGroup(_ sender: Any) {
        designatedGroupButton.switchToGroup(groupNumber: 3)
        tableStatus.switchToGroup(groupNumber: 3)
        reloadTable()
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}
