//
//  GradeTableViewCell.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/9.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit

class GradeTableViewCell: UITableViewCell {

    @IBOutlet var schoolLabel: UILabel!
    @IBOutlet var departmentLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!

    private let inset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    private let cornerRadius: CGFloat = 16
    private let minimumContentHeight: CGFloat = 80
    private let gradeLabelRightPadding: CGFloat = 24
    private let cardView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        clipsToBounds = false
        contentView.clipsToBounds = false
        selectionStyle = .none
        configureTypography()
        setupCardView()
    }

    private func configureTypography() {
        schoolLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        schoolLabel.textColor = .white
        schoolLabel.numberOfLines = 2
        schoolLabel.lineBreakMode = .byTruncatingTail
        departmentLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        departmentLabel.textColor = Theme.mutedText
        departmentLabel.numberOfLines = 2
        gradeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        gradeLabel.textColor = Theme.accent
        gradeLabel.numberOfLines = 2
        gradeLabel.textAlignment = .right
        gradeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = Theme.cardBackground
        cardView.layer.cornerRadius = cornerRadius
        cardView.layer.masksToBounds = true
        contentView.insertSubview(cardView, at: 0)

        [schoolLabel, departmentLabel, gradeLabel].forEach { label in
            guard let label = label else { return }
            detachFromStoryboard(label)
            label.translatesAutoresizingMaskIntoConstraints = false
        }

        let leftStack = UIStackView(arrangedSubviews: [schoolLabel, departmentLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(leftStack)
        cardView.addSubview(gradeLabel)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset.left),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset.right),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset.top),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset.bottom),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: minimumContentHeight),

            leftStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            leftStack.trailingAnchor.constraint(equalTo: gradeLabel.leadingAnchor, constant: -6),
            leftStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            leftStack.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor, constant: 12),
            leftStack.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12),

            gradeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -gradeLabelRightPadding),
            gradeLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            gradeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }

    private func detachFromStoryboard(_ view: UIView) {
        var ancestor = view.superview
        while let superview = ancestor {
            superview.constraints
                .filter { $0.firstItem === view || $0.secondItem === view }
                .forEach { $0.isActive = false }
            ancestor = superview.superview
        }

        if let stackView = view.superview as? UIStackView {
            stackView.removeArrangedSubview(view)
        }

        view.removeFromSuperview()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        departmentLabel.isHidden = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        Theme.applyCardShadow(to: layer, cornerRadius: cornerRadius, shadowRect: cardView.frame.insetBy(dx: -2, dy: -2))
    }
}
