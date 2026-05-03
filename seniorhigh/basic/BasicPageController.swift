//
//  BasicPageController.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/1.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BasicPageController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var switchToAllSchoolButton: UIButton!
    @IBOutlet weak var switchToFirstGroupButton: UIButton!
    @IBOutlet weak var switchToSecondGroupButton: UIButton!
    @IBOutlet weak var groupButtonStackView: UIStackView!

    var tableStatus = BasicTableStatus()
    var basicGroupButton: BasicGroupButton!

    //MARK: Actions

    override func viewDidLoad() {
        super.viewDidLoad()
        Theme.addGradientBackground(to: view)
        Theme.styleTableView(tableView)
        configureGroupStackLayout()
        basicGroupButton = BasicGroupButton(
            switchToAllSchoolButton: self.switchToAllSchoolButton,
            switchToFirstGroupButton: self.switchToFirstGroupButton,
            switchToSecondGroupButton: self.switchToSecondGroupButton)
        initialAd()
        setBackButtonVisibility()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStatus.cellCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableStatus.buildCell(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableStatus.clickCell(viewController: self, indexPath: indexPath)
        reloadTable()
    }

    func reloadTable() {
        UIView.transition(with: tableView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
        setBackButtonVisibility()
    }

    private func setBackButtonVisibility() {
        if tableStatus.getGroupStatus() == .schoolDepartment && tableStatus.getSchoolDepartmentStatus() == .department {
            backButton.isEnabled = true
            backButton.tintColor = Theme.accent
        } else {
            backButton.isEnabled = false
            backButton.tintColor = Theme.accent.withAlphaComponent(0.2)
        }
    }

    private func configureGroupStackLayout() {
        groupButtonStackView.isLayoutMarginsRelativeArrangement = true
        groupButtonStackView.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        groupButtonStackView.spacing = 12
    }

    @IBAction func backPressed(_ sender: Any) {
        if tableStatus.getGroupStatus() == .schoolDepartment {
            tableStatus.switchToSchool()
            reloadTable()
        }
    }

    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if basicGroupButton.switchToLeft() {
            if basicGroupButton.currentIndex == 0 {
                tableStatus.switchToSchool()
            } else {
                tableStatus.switchToGroup(groupNumber: basicGroupButton.currentIndex)
            }
            reloadTable()
        }
    }

    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if basicGroupButton.switchToRight() {
            if basicGroupButton.currentIndex == 0 {
                tableStatus.switchToSchool()
            } else {
                tableStatus.switchToGroup(groupNumber: basicGroupButton.currentIndex)
            }
            reloadTable()
        }
    }

    @IBAction func switchToAllSchool(_ sender: Any) {
        basicGroupButton.switchToAllSchool()
        tableStatus.switchToSchool()
        reloadTable()
    }

    @IBAction func switchToFirstGroup(_ sender: Any) {
        basicGroupButton.switchToGroup(groupNumber: 1)
        tableStatus.switchToGroup(groupNumber: 1)
        reloadTable()
    }

    @IBAction func switchToSecondGroup(_ sender: Any) {
        basicGroupButton.switchToGroup(groupNumber: 2)
        tableStatus.switchToGroup(groupNumber: 2)
        reloadTable()
    }

    func initialAd() {
        let bannerView: BannerView = AdManager.buildBannerView(viewController: self)
        AdManager.addBottomBannerViewToView(view: view, bannerView: bannerView)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}
