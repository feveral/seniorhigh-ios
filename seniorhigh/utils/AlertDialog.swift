//
//  AlertDialog.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/9/4.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit

class AlertDialog: UIViewController {

    var dialogHeight: CGFloat = 150
    var dialogWidth: CGFloat = UIScreen.main.bounds.width - 60
    
    private func addBackgroundDismissButton() {
        let overlayButton = UIButton(type: .custom)
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        overlayButton.backgroundColor = .clear
        overlayButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        view.insertSubview(overlayButton, at: 0)
        NSLayoutConstraint.activate([
            overlayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayButton.topAnchor.constraint(equalTo: view.topAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        addBackgroundDismissButton()
    }

    func attachActionButtons(favoriteButton: UIButton, to stackView: UIStackView) {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("關閉", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        closeButton.layer.cornerRadius = 22
        closeButton.layer.masksToBounds = true
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)

        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.layer.cornerRadius = 22
        favoriteButton.layer.masksToBounds = true

        let row = UIStackView(arrangedSubviews: [favoriteButton, closeButton])
        row.axis = .horizontal
        row.spacing = 12
        row.distribution = .fillEqually
        stackView.addArrangedSubview(row)

        let heightConstraint = favoriteButton.heightAnchor.constraint(equalToConstant: 48)
        heightConstraint.priority = .required
        heightConstraint.isActive = true
        closeButton.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor).isActive = true
    }
}
