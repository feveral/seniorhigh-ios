//
//  UnifyDialog.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/17.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit

class UnifyDialog: AlertDialog {
    
    private var _containerView = UIView()
    private var _containerStackView = UIStackView()
    private var _firstYearGrades: [UnifyGrade] = [UnifyGrade()]
    private var _secondYearGrades: [UnifyGrade] = [UnifyGrade()]
    private var _favoriteButton = UIImageView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        _containerStackView.alignment = .center
        _containerStackView.distribution = .fillEqually
        _containerStackView.axis = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public static func buildDialog(school: String, department: String) -> UnifyDialog {
        let firstYear = Config.Application.unifyFirstYear
        let secondYear = Config.Application.unifySecondYear
        let firstYearGrades = UnifyGrade.find(year: firstYear, school: school, department: department)
        let secondYearGrades = UnifyGrade.find(year: secondYear, school: school, department: department)
        let dialog = UnifyDialog()
        dialog.setFirstYearGrades(grades: firstYearGrades)
        dialog.setSecondYearGrades(grades: secondYearGrades)
        dialog.modalPresentationStyle = UIModalPresentationStyle.custom
        return dialog
    }
    
    public func setFirstYearGrades(grades: [UnifyGrade]) {
        self._firstYearGrades = grades
        if (!grades.isEmpty) {
            addTitleLabel(grade: grades[0])
            addYearLabel(grade: grades[0])
            addGradeLabel(grades: grades)
        }
    }
    
    public func setSecondYearGrades(grades: [UnifyGrade]) {
        self._secondYearGrades = grades
        if (!grades.isEmpty) {
            addYearLabel(grade: grades[0])
            addGradeLabel(grades: grades)
        }
        addFavoriteButton()
    }
    
    private func addDialogHeight() {
        dialogHeight += 30
        refreshContainer()
    }
    
    private func refreshContainer() {
        _containerStackView.frame = CGRect(x: 12.5, y: 12.5, width: dialogWidth-25, height: dialogHeight-25)
        _containerView.frame = CGRect(x: 30, y: (UIScreen.main.bounds.height-dialogHeight) / 2, width: dialogWidth, height: self.dialogHeight)
        _containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        _containerView.layer.cornerRadius = 20.0
        _containerView.clipsToBounds = true
    }
    
    private func addTitleLabel(grade: UnifyGrade) {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        title.text = "\(grade.school) \(grade.department)"
        title.textColor = .black
        title.numberOfLines = 2
        addDialogHeight()
        _containerStackView.addArrangedSubview(title)
    }
    
    private func addYearLabel(grade: UnifyGrade) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        label.text = "---\(grade.year)年度---"
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addDialogHeight()
        _containerStackView.addArrangedSubview(label)
    }
    
    private func addGradeLabel(grades: [UnifyGrade]) {
        for grade in grades {
            let stack = UIStackView()
            let groupPromptLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
            let groupLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
            let gradePromptLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
            let gradeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
            groupPromptLabel.textColor = UIColor.black
            groupPromptLabel.text = "類群 "
            groupLabel.text = grade.groupName
            groupLabel.textColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
            gradePromptLabel.textColor = UIColor.black
            gradePromptLabel.text = "     總分 "
            gradeLabel.text = String(grade.grade)
            gradeLabel.textColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
            stack.axis = .horizontal
            stack.addArrangedSubview(groupPromptLabel)
            stack.addArrangedSubview(groupLabel)
            stack.addArrangedSubview(gradePromptLabel)
            stack.addArrangedSubview(gradeLabel)
            addDialogHeight()
            _containerStackView.addArrangedSubview(stack)
        }
    }
    
    func addFavoriteButton() {
        let stackView = UIStackView(frame: CGRect(x:0, y:0, width: dialogWidth, height: 20))
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
        let isExist = Favorite.isFavoriteExist(favorite: Favorite(examine: Config.Text.UNIFY, school: _firstYearGrades[0].school, department: _firstYearGrades[0].department))
        if (isExist) {
            _favoriteButton.image = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
        } else {
            _favoriteButton.image = UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @objc func favoriteButtonClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        Favorite.saveOrDelete(favorite: Favorite(examine: Config.Text.UNIFY, school: _firstYearGrades[0].school, department: _firstYearGrades[0].department))
        refreshFavoriteStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshContainer()
        _containerView.addSubview(_containerStackView)
        addCloseButton()
        view.addSubview(_containerView)
        refreshFavoriteStatus()
    }
}
