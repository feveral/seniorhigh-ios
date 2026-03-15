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
    private var _cardContentView = UIView()
    private var _containerStackView = UIStackView()
    private var _firstYearGrade = DesignatedGrade()
    private var _secondYearGrade = DesignatedGrade()
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
            addExamBadge(text: "分科")
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
    
    private func addTitleLabel(grade: DesignatedGrade) {
        let title = UILabel()
        title.text = "\(grade.school) \(grade.department)"
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        title.numberOfLines = 0
        _containerStackView.addArrangedSubview(title)
    }
    
    private func addYearLabel(grade: DesignatedGrade) {
        let label = UILabel()
        label.text = "\(grade.year) 年度"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Theme.mutedText
        label.textAlignment = .left
        _containerStackView.addArrangedSubview(label)
    }

    private func addSubjectWeightsLabel(grade: DesignatedGrade) {
        guard !grade.subjectWeight.subjectWeights.isEmpty else { return }
        let container = buildRowContainer()
        let title = UILabel()
        title.text = "檢定權重"
        title.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        title.textColor = Theme.mutedText
        let weightsStack = UIStackView()
        weightsStack.axis = .vertical
        weightsStack.alignment = .leading
        weightsStack.spacing = 4
        for (subject, weight) in grade.subjectWeight.subjectWeights {
            let label = UILabel()
            label.text = "\(subject)  ·  \(weight)"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            weightsStack.addArrangedSubview(label)
        }
        let contentStack = UIStackView(arrangedSubviews: [title, weightsStack])
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            contentStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        _containerStackView.addArrangedSubview(container)
    }
    
    private func addGradePeopleLabel(grade: DesignatedGrade) {
        let stats = [
            ("總分", String(grade.grade)),
            ("平均", String(format:"%.2f", grade.weightedGrade)),
            ("人數", "\(grade.people)")
        ]
        let container = buildRowContainer()
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.distribution = .fillEqually
        row.translatesAutoresizingMaskIntoConstraints = false
        for (title, value) in stats {
            row.addArrangedSubview(buildStatBlock(title: title, value: value))
        }
        container.addSubview(row)
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        _containerStackView.addArrangedSubview(container)
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
        let isExist = Favorite.isFavoriteExist(favorite: Favorite(examine: Config.Text.DESIGNATED, school: _firstYearGrade.school, department: _firstYearGrade.department))
        if (isExist) {
            _favoriteButton.setImage(UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            _favoriteButton.setImage(UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc func favoriteButtonClicked() {
        Favorite.saveOrDelete(favorite: Favorite(examine: Config.Text.DESIGNATED, school: _firstYearGrade.school, department: _firstYearGrade.department))
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
    
    private func buildStatBlock(title: String, value: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = Theme.mutedText
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = Theme.accent
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        return stack
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
