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
    
    //MARK: properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    var tableStatus = BasicTableStatus()
    
    //MARK: Actions

    override func viewDidLoad() {
        initialAd()
        setBackButtonVisibility()
        tableView.backgroundColor = UIColor.white
    }
    
    @IBAction func backPressed(_ sender: Any) {
        tableStatus.switchToSchool()
        reloadTable()
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
        if (tableStatus.getSchoolDepartmentStatus() == .department) {
            backButton.isEnabled = true
            backButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            backButton.isEnabled = false
            backButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    func initialAd() {
        let bannerView: GADBannerView = AdManager.buildBannerView(viewController: self)
        AdManager.addBottomBannerViewToView(view: view, bannerView: bannerView)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }

}
