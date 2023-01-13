//
//  BasicDialog.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/15.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BasicDialog: AlertDialog {
    
    private var _containerView = UIView()
    private var _containerStackView = UIStackView()
    private var _firstYearGrade = BasicGrade()
    private var _secondYearGrade = BasicGrade()
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
    
    static func buildDialog(school: String, department: String) -> BasicDialog {
        let firstYear = Config.Application.basicFirstYear
        let secondYear = Config.Application.basicSecondYear
        let firstYearGrade = BasicGrade.find(year: firstYear, school: school, department: department)
        let secondYearGrade = BasicGrade.find(year: secondYear, school: school, department: department)
        let dialog = BasicDialog()
        dialog.setFirstYearGrade(grade: firstYearGrade)
        dialog.setSecondYearGrade(grade: secondYearGrade)
        dialog.modalPresentationStyle = UIModalPresentationStyle.custom
        return dialog
    }
    
    public func setFirstYearGrade(grade: BasicGrade) {
        self._firstYearGrade = grade
        if (!grade.isEmpty) {
            addTitleLabel(grade: grade)
            addYearLabel(grade: grade)
            addGradeLabel(grade: grade)
        }
    }
    
    public func setSecondYearGrade(grade: BasicGrade) {
        self._secondYearGrade = grade
        if (!grade.isEmpty) {
            addYearLabel(grade: grade)
            addGradeLabel(grade: grade)
        }
        addFavoriteButton()
    }
    
    private func addDialogHeight() {
        dialogHeight += 20
        refreshContainer()
    }
    
    private func refreshContainer() {
        _containerStackView.frame = CGRect(x: 12.5, y: 12.5, width: dialogWidth-25, height: dialogHeight-25)
        _containerView.frame = CGRect(x: 30, y: (UIScreen.main.bounds.height-dialogHeight) / 2, width: dialogWidth, height: self.dialogHeight)
        _containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        _containerView.layer.cornerRadius = 20.0
        _containerView.clipsToBounds = true
    }
    
    private func addTitleLabel(grade: BasicGrade) {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        title.text = "\(grade.school) \(grade.department)"
        title.textColor = .black
        title.numberOfLines = 2
        if (title.text!.count >= 16) {
            dialogHeight += 70
        }
        addDialogHeight()
        _containerStackView.addArrangedSubview(title)
    }
    
    private func addYearLabel(grade: BasicGrade) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
        label.text = "---\(grade.year)年度---"
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addDialogHeight()
        _containerStackView.addArrangedSubview(label)
    }
    
    private func addGradeLabel(grade: BasicGrade) {
        let gradePromptString = ["篩選順序一", "篩選順序二", "篩選順序三", "篩選順序四", "篩選順序五"]
        for i in 1...grade.subjectGrade.order {
            let container = UIView()
            let gradePromptLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
            gradePromptLabel.textColor = UIColor.black
            gradePromptLabel.text = gradePromptString[i-1]
            let subjectLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
            subjectLabel.textColor = UIColor.black
            subjectLabel.text = grade.subjectGrade.getSubject(order: i)
            subjectLabel.textAlignment = NSTextAlignment.center
            let gradeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: dialogWidth, height: 3))
            gradeLabel.text = String(grade.subjectGrade.getGrade(order: i))
            gradeLabel.textColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
            gradeLabel.textAlignment = NSTextAlignment.center
            container.addSubview(gradePromptLabel)
            container.addSubview(subjectLabel)
            container.addSubview(gradeLabel)
            
            addDialogHeight()
            _containerStackView.addArrangedSubview(container)
            
            let containerWidth = dialogWidth - 30
            
            container.snp.makeConstraints { make in
                make.width.equalTo(containerWidth)
                make.centerX.equalToSuperview()
            }
            gradePromptLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.width.equalTo(containerWidth * 0.3)
                make.top.equalToSuperview()
            }
            subjectLabel.snp.makeConstraints { make in
                make.leading.equalTo(gradePromptLabel.snp.trailing).offset(5)
                make.width.equalTo(containerWidth * 0.55)
                make.top.equalToSuperview()
            }
            gradeLabel.snp.makeConstraints { make in
                make.leading.equalTo(subjectLabel.snp.trailing).offset(5)
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalToSuperview()
            }
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
        let isExist = Favorite.isFavoriteExist(favorite: Favorite(examine: Config.Text.BASIC, school: _firstYearGrade.school, department: _firstYearGrade.department))
        if (isExist) {
            _favoriteButton.image = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
        } else {
            _favoriteButton.image = UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @objc func favoriteButtonClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        Favorite.saveOrDelete(favorite: Favorite(examine: Config.Text.BASIC, school: _firstYearGrade.school, department: _firstYearGrade.department))
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
