//
//  FavoritePageController.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/28.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTabs
import MaterialComponents


class FavoritePageController: UIViewController,UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {

    var tableStatus: FavoriteTableStatus = FavoriteTableStatus()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStatus.cellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableStatus.buildCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableStatus.clickCell(viewController: self, indexPath: indexPath)
    }
    
    func reloadTable() {
        setVisibility()
        UIView.transition(with: tableView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    //MARK: Properties
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var typingPrompt: UILabel!
    
    //MARK: Actions
    
    @IBAction func refreshClick(_ sender: Any) {
        tableStatus.refresh()
        reloadTable()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            tableStatus.switchToDesignated()
            reloadTable()
        } else if (sender.selectedSegmentIndex == 1) {
            tableStatus.switchToBasic()
            reloadTable()
        } else if (sender.selectedSegmentIndex == 2) {
            tableStatus.switchToUnify()
            reloadTable()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Theme.addGradientBackground(to: view)
        Theme.styleTableView(tableView)
        Theme.styleSegmentedControl(segmentControl)
        typingPrompt = UILabel()
        typingPrompt.textAlignment = .center
        typingPrompt.text = "目前沒有任何校系加入收藏"
        Theme.styleEmptyStateLabel(typingPrompt)
        typingPrompt.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typingPrompt)
        NSLayoutConstraint.activate([
            typingPrompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            typingPrompt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            typingPrompt.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        setVisibility()
    }
    
    func setVisibility() {
        if  tableStatus.cellCount() == 0 {
            typingPrompt.isHidden = false
            tableView.isHidden = true
        } else {
            typingPrompt.isHidden = true
            tableView.isHidden = false
        }
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}
