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
    
    func addCloseButton() {
        let buttonUp = UIButton(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height-dialogHeight / 2)))
        let buttonDown = UIButton(frame: CGRect(x:0, y: (UIScreen.main.bounds.height+dialogHeight)/2, width: UIScreen.main.bounds.width, height: 200))
        buttonUp.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        buttonDown.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        view.addSubview(buttonUp)
        view.addSubview(buttonDown)
    }
    
    @objc func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
    }
}
