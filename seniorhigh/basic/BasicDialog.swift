//
//  BasicDialog.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/15.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit
class BasicDialog: AlertDialog {
    
    private var _containerView = UIView()
    private var _cardContentView = UIView()
    private var _containerStackView = UIStackView()
    private var _firstYearGrade = BasicGrade()
    private var _secondYearGrade = BasicGrade()
    private var _favoriteButton = UIButton(type: .system)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        _containerStackView.alignment = .fill
        _containerStackView.distribution = .fill
        _containerStackView.axis = .vertical
        _containerStackView.spacing = 16
        _containerStackView.isLayoutMarginsRelativeArrangement = true
        _containerStackView.layoutMargins = UIEdgeInsets(top: 28, left: 24, bottom: 28, right: 24)
        _containerStackView.translatesAutoresizingMaskIntoConstraints = false
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
            addExamBadge(text: "學測")
            addTitleLabel(grade: grade)
            addYearLabel(grade: grade)
            addGradeLabel(grade: grade)
        }
    }
    
    public func setSecondYearGrade(grade: BasicGrade) {
        self._secondYearGrade = grade
        if (!grade.isEmpty && false) { // Hide second year UI, keep code for future use
            addYearLabel(grade: grade)
            addGradeLabel(grade: grade)
        }
        addFavoriteButton()
    }
    
    private func formatGradeValue(_ grade: Double) -> String {
        if grade.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(grade))
        } else {
            return String(grade)
        }
    }
    
    private func addTitleLabel(grade: BasicGrade) {
        let title = UILabel()
        title.text = "\(grade.school) \(grade.department)"
        title.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        title.textColor = .white
        title.numberOfLines = 0
        _containerStackView.addArrangedSubview(title)
    }
    
    private func addYearLabel(grade: BasicGrade) {
        let label = UILabel()
        label.text = "\(grade.year) 年度"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Theme.mutedText
        label.textAlignment = .left
        _containerStackView.addArrangedSubview(label)
    }
    
    private func addGradeLabel(grade: BasicGrade) {
        let gradePromptString = ["篩選順序一", "篩選順序二", "篩選順序三", "篩選順序四", "篩選順序五"]
        if grade.subjectGrade.order == 0 {
            return
        }
        for i in 1...grade.subjectGrade.order {
            let rowContainer = buildRowContainer()
            let row = UIStackView()
            row.axis = .horizontal
            row.alignment = .center
            row.spacing = 12
            row.distribution = .fill
            row.translatesAutoresizingMaskIntoConstraints = false

            let prompt = UILabel()
            prompt.textColor = Theme.mutedText
            prompt.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            prompt.text = gradePromptString[i-1]
            prompt.numberOfLines = 1
            prompt.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let subjectLabel = UILabel()
            subjectLabel.textColor = .white
            subjectLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            subjectLabel.text = grade.subjectGrade.getSubject(order: i)
            subjectLabel.numberOfLines = 2
            
            let valueLabel = UILabel()
            valueLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
            valueLabel.textColor = Theme.accent
            valueLabel.text = formatGradeValue(grade.subjectGrade.getGrade(order: i))
            valueLabel.textAlignment = .right
            valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            row.addArrangedSubview(prompt)
            row.addArrangedSubview(subjectLabel)
            row.addArrangedSubview(valueLabel)
            rowContainer.addSubview(row)
            _containerStackView.addArrangedSubview(rowContainer)
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: rowContainer.leadingAnchor, constant: 12),
                row.trailingAnchor.constraint(equalTo: rowContainer.trailingAnchor, constant: -12),
                row.topAnchor.constraint(equalTo: rowContainer.topAnchor, constant: 10),
                row.bottomAnchor.constraint(equalTo: rowContainer.bottomAnchor, constant: -10)
            ])
        }
    }
    
    func addFavoriteButton() {
        _favoriteButton.setTitle("加入收藏", for: .normal)
        _favoriteButton.setTitleColor(.white, for: .normal)
        _favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        _favoriteButton.setImage(UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate), for: .normal)
        _favoriteButton.tintColor = .white
        _favoriteButton.backgroundColor = Theme.accent
        _favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        _favoriteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        _favoriteButton.semanticContentAttribute = .forceLeftToRight
        _favoriteButton.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
        attachActionButtons(favoriteButton: _favoriteButton, to: _containerStackView)
    }
    
    func refreshFavoriteStatus() {
        let isExist = Favorite.isFavoriteExist(favorite: Favorite(examine: Config.Text.BASIC, school: _firstYearGrade.school, department: _firstYearGrade.department))
        if (isExist) {
            _favoriteButton.setImage(UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            _favoriteButton.setImage(UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc func favoriteButtonClicked() {
        Favorite.saveOrDelete(favorite: Favorite(examine: Config.Text.BASIC, school: _firstYearGrade.school, department: _firstYearGrade.department))
        refreshFavoriteStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        configureContainerView()
        refreshFavoriteStatus()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Theme.applyCardShadow(to: _containerView.layer, cornerRadius: 28, shadowRect: _containerView.bounds)
    }
    
    private func configureContainerView() {
        view.addSubview(_containerView)
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        _containerView.layer.cornerRadius = 28
        _containerView.layer.masksToBounds = false
        NSLayoutConstraint.activate([
            _containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            _containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            _containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            _containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 440)
        ])
        _cardContentView.translatesAutoresizingMaskIntoConstraints = false
        _cardContentView.backgroundColor = Theme.cardBackground
        _cardContentView.layer.cornerRadius = 28
        _cardContentView.layer.masksToBounds = true
        _containerView.addSubview(_cardContentView)
        NSLayoutConstraint.activate([
            _cardContentView.leadingAnchor.constraint(equalTo: _containerView.leadingAnchor),
            _cardContentView.trailingAnchor.constraint(equalTo: _containerView.trailingAnchor),
            _cardContentView.topAnchor.constraint(equalTo: _containerView.topAnchor),
            _cardContentView.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor)
        ])
        _cardContentView.addSubview(_containerStackView)
        NSLayoutConstraint.activate([
            _containerStackView.leadingAnchor.constraint(equalTo: _cardContentView.leadingAnchor),
            _containerStackView.trailingAnchor.constraint(equalTo: _cardContentView.trailingAnchor),
            _containerStackView.topAnchor.constraint(equalTo: _cardContentView.topAnchor),
            _containerStackView.bottomAnchor.constraint(equalTo: _cardContentView.bottomAnchor)
        ])
    }
    
    private func buildRowContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        container.layer.cornerRadius = 18
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }

    private func addExamBadge(text: String) {
        let badge = UILabel()
        badge.text = text
        badge.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        badge.textAlignment = .center
        badge.textColor = Theme.accent
        badge.backgroundColor = Theme.accent.withAlphaComponent(0.12)
        badge.layer.cornerRadius = 13
        badge.layer.masksToBounds = true
        badge.heightAnchor.constraint(equalToConstant: 26).isActive = true
        _containerStackView.addArrangedSubview(badge)
    }
}
