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
    private var _cardContentView = UIView()
    private var _containerStackView = UIStackView()
    private var _firstYearGrades: [UnifyGrade] = [UnifyGrade()]
    private var _secondYearGrades: [UnifyGrade] = [UnifyGrade()]
    private var _favoriteButton = UIButton(type: .system)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        _containerStackView.alignment = .fill
        _containerStackView.distribution = .fill
        _containerStackView.axis = .vertical
        _containerStackView.spacing = 12
        _containerStackView.isLayoutMarginsRelativeArrangement = true
        _containerStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        _containerStackView.translatesAutoresizingMaskIntoConstraints = false
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
            addExamBadge(text: "統測")
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
    
    private func addTitleLabel(grade: UnifyGrade) {
        let title = UILabel()
        title.text = "\(grade.school) \(grade.department)"
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        title.numberOfLines = 0
        _containerStackView.addArrangedSubview(title)
    }
    
    private func addYearLabel(grade: UnifyGrade) {
        let label = UILabel()
        label.text = "\(grade.year) 年度"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Theme.mutedText
        _containerStackView.addArrangedSubview(label)
    }
    
    private func addGradeLabel(grades: [UnifyGrade]) {
        for grade in grades {
            let container = buildRowContainer()
            let row = UIStackView()
            row.axis = .vertical
            row.spacing = 4
            row.translatesAutoresizingMaskIntoConstraints = false
            let groupRow = UIStackView()
            groupRow.axis = .horizontal
            groupRow.alignment = .top
            groupRow.spacing = 8
            let groupLabel = UILabel()
            groupLabel.text = grade.groupName
            groupLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            groupLabel.textColor = Theme.accent
            groupLabel.numberOfLines = 2
            let badge = UILabel()
            badge.text = "類群"
            badge.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            badge.textColor = Theme.mutedText
            groupRow.addArrangedSubview(badge)
            groupRow.addArrangedSubview(groupLabel)
            let scoreLabel = UILabel()
            scoreLabel.text = "總分 \(formatScore(grade.grade))"
            scoreLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 19, weight: .semibold)
            scoreLabel.textColor = .white
            scoreLabel.textAlignment = .left
            row.addArrangedSubview(groupRow)
            row.addArrangedSubview(scoreLabel)
            container.addSubview(row)
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
                row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
                row.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
                row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
            ])
            _containerStackView.addArrangedSubview(container)
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
        let isExist = Favorite.isFavoriteExist(favorite: Favorite(examine: Config.Text.UNIFY, school: _firstYearGrades[0].school, department: _firstYearGrades[0].department))
        if (isExist) {
            _favoriteButton.setImage(UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            _favoriteButton.setImage(UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc func favoriteButtonClicked() {
        Favorite.saveOrDelete(favorite: Favorite(examine: Config.Text.UNIFY, school: _firstYearGrades[0].school, department: _firstYearGrades[0].department))
        refreshFavoriteStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            _containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 460)
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

    private func formatScore(_ value: Double) -> String {
        return value.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", value) : String(format: "%.2f", value)
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
