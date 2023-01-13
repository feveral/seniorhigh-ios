//
//  DesignatedDialog.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/13.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit
import Foundation

class DesignatedDialog: AlertDialog {
    
    private var _containerView = UIView()
    private var _containerStackView = UIStackView()
    private var _firstYearGrade = DesignatedGrade()
    private var _secondYearGrade = DesignatedGrade()
    private var _favoriteButton = UIImageView()

    init() {
        super.init(nibName: nil, bundle: nil)
        _containerStackView.alignment = .center
        _containerStackView.distribution = .fillProportionally
        _containerStackView.axis = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public static func buildDialog(school: String, department: String) -> DesignatedDialog {
        let firstYear = Config.Application.designatedFirstYear
        let secondYear = Config.Application.designatedSecondYear
        let firstYearGrade = DesignatedGrade.find(year: firstYear, school: school, department: department)
        let secondYearGrade = DesignatedGrade.find(year: secondYear, school: school, department: department)
        let dialog = DesignatedDialog()
        dialog.setFirstYearGrade(grade: firstYearGrade)
        dialog.setSecondYearGrade(grade: secondYearGrade)
        dialog.modalPresentationStyle = UIModalPresentationStyle.custom
        return dialog
    }
    
    public func setFirstYearGrade(grade: DesignatedGrade) {
        self._firstYearGrade = grade
        if (!grade.isEmpty) {
            addTitleLabel(grade: grade)
            addYearLabel(grade: grade)
            addSubjectWeightsLabel(grade: grade)
            addGradePeopleLabel(grade: grade)
        }
    }
    
    public func setSecondYearGrade(grade: DesignatedGrade) {
        self._secondYearGrade = grade
        if (!grade.isEmpty) {
            addYearLabel(grade: grade)
            addSubjectWeightsLabel(grade: grade)
            addGradePeopleLabel(grade: grade)
        }
        addFavoriteButton()
    }
    
    private func addDialogHeight() {
        dialogHeight += 20
        refreshContainer()
    }
    
    private func refreshContainer() {
        _containerStackView.frame = CGRect(x: 12.5, y: 12.5, width: dialogWidth-20, height: dialogHeight-25)
        _containerView.frame = CGRect(x: 30, y: (UIScreen.main.bounds.height-dialogHeight) / 2, width: dialogWidth, height: dialogHeight)
        _containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        _containerView.layer.cornerRadius = 20.0
        _containerView.clipsToBounds = true
    }
    
    private func addTitleLabel(grade: DesignatedGrade) {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 6))
        title.text = "\(grade.school) \(grade.department)"
        title.textColor = .black
        title.numberOfLines = 2
        if (title.text!.count >= 16) {
            dialogHeight += 70
        }
        addDialogHeight()
        _containerStackView.addArrangedSubview(title)
    }
    
    private func addYearLabel(grade: DesignatedGrade) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        label.text = "---\(grade.year)年度---"
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addDialogHeight()
        _containerStackView.addArrangedSubview(label)
    }

    private func addSubjectWeightsLabel(grade: DesignatedGrade) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        var swString = ""
        for (s,w) in grade.subjectWeight.subjectWeights {
            swString = swString + "\(s) \(String(w)) "
        }
        label.text = swString
        label.textColor = .black
        addDialogHeight()
        _containerStackView.addArrangedSubview(label)
    }
    
    private func addGradePeopleLabel(grade: DesignatedGrade) {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: dialogHeight))
        stackView.axis = .horizontal
        let gradePrompt = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        let gradeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        let balancedPrompt = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        let balancedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        let peoplePrompt = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        let peopleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        gradePrompt.textColor = UIColor.black
        gradePrompt.text = "總分 "
        gradeLabel.text = "\(grade.grade)"
        balancedPrompt.textColor = UIColor.black
        balancedPrompt.text = "   平均 "
        balancedLabel.text = "\(String(format:"%.2f", grade.weightedGrade))"
        balancedLabel.textColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        peoplePrompt.textColor = UIColor.black
        peoplePrompt.text = "   人數 "
        peopleLabel.text = "\(grade.people)"
        gradeLabel.textColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        stackView.addArrangedSubview(gradePrompt)
        stackView.addArrangedSubview(gradeLabel)
        stackView.addArrangedSubview(balancedPrompt)
        stackView.addArrangedSubview(balancedLabel)
        stackView.addArrangedSubview(peoplePrompt)
        stackView.addArrangedSubview(peopleLabel)
        addDialogHeight()
        _containerStackView.addArrangedSubview(stackView)
    }
    
    func addFavoriteButton() {
        let stackView = UIStackView(frame: CGRect(x:0, y:0, width: dialogWidth, height: 40))
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        _favoriteButton.frame = CGRect(x:0, y:0, width: 20, height: 20)
        _favoriteButton.image = UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate)
        _favoriteButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonClicked(tapGestureRecognizer:)))
        _favoriteButton.isUserInteractionEnabled = true
        _favoriteButton.addGestureRecognizer(tapGestureRecognizer)
        stackView.addArrangedSubview(_favoriteButton)
        _containerStackView.addArrangedSubview(stackView)
    }
    
    func refreshFavoriteStatus() {
        let isExist = Favorite.isFavoriteExist(favorite: Favorite(examine: Config.Text.DESIGNATED, school: _firstYearGrade.school, department: _firstYearGrade.department))
        if (isExist) {
            _favoriteButton.image = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
        } else {
            _favoriteButton.image = UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @objc func favoriteButtonClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        Favorite.saveOrDelete(favorite: Favorite(examine: Config.Text.DESIGNATED, school: _firstYearGrade.school, department: _firstYearGrade.department))
        refreshFavoriteStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshContainer()
        _containerView.addSubview(_containerStackView)
        view.addSubview(_containerView)
        refreshFavoriteStatus()
    }
}

