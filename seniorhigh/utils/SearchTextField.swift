//
//  SearchTextField.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/19.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {

    private let padding = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 24)
    private let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    
    init() {
        super.init(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width * 0.85, height: 48))
        translatesAutoresizingMaskIntoConstraints = false
        semanticContentAttribute = .forceLeftToRight
        backgroundColor = Theme.cardBackground.withAlphaComponent(0.95)
        textColor = .white
        font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        layer.cornerRadius = 22
        layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        layer.borderWidth = 1
        layer.shadowColor = Theme.shadowColor
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 16
        layer.masksToBounds = false
        textAlignment = .left
        heightAnchor.constraint(equalToConstant: 52).isActive = true
        clearButtonMode = .whileEditing
        configureLeftIcon()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setPlaceholder(_ placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: Theme.mutedText])
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by:padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by:padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by:padding)
    }

    private func configureLeftIcon() {
        iconImageView.tintColor = Theme.mutedText
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

}
