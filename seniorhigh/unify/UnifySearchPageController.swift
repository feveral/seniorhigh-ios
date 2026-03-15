//
//  UnifySearchPageController.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/19.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit
import GoogleMobileAds

class UnifySearchPageController: UIViewController,UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var typingPrompt: UILabel!
    var searchTextField = SearchTextField()
    var gradeList: [UnifyGrade] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! GradeTableViewCell
        cell.schoolLabel?.text = gradeList[indexPath.row].school
        cell.departmentLabel?.text = gradeList[indexPath.row].department
        cell.gradeLabel?.text = String(format: "%.2f", gradeList[indexPath.row].grade)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialog = UnifyDialog.buildDialog(school: gradeList[indexPath.row].school, department: gradeList[indexPath.row].department)
        dialog.transitioningDelegate = self
        present(dialog, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text=searchTextField.text {
            gradeList = UnifyGrade.findByKeyword(year: Config.Application.unifyFirstYear, keyWord: text)
            gradeList = UnifyGrade.sortHighToLow(grades: gradeList)
            reloadTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        initialAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    func initialUI() {
        Theme.addGradientBackground(to: view)
        searchTextField.setPlaceholder("搜尋統測成績")

        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9)
        ])
        navigationItem.titleView = titleContainer

        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.delegate = self

        typingPrompt = UILabel()
        typingPrompt.translatesAutoresizingMaskIntoConstraints = false
        typingPrompt.textAlignment = .center
        typingPrompt.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        typingPrompt.text = "輸入關鍵字以搜尋校系"
        typingPrompt.textColor = Theme.mutedText
        view.addSubview(typingPrompt)
        NSLayoutConstraint.activate([
            typingPrompt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            typingPrompt.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            typingPrompt.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            typingPrompt.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])

        Theme.styleTableView(tableView)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag

        setVisibility()
        hideKeyboardWhenTappedAround()
    }
    
    func setVisibility() {
        if gradeList.count == 0 {
            typingPrompt.isHidden = false
            tableView.isHidden = true
        } else {
            typingPrompt.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func reloadTable() {
        setVisibility()
        UIView.transition(with: tableView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    func initialAd() {
        let bannerView: BannerView = AdManager.buildBannerView(viewController: self)
        AdManager.addBottomBannerViewToView(view: view, bannerView: bannerView)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DialogPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}
