//
//  UnifyGroupButton.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/17.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import Foundation
import UIKit

class UnifyGroupButton {
    
    var currentIndex: Int  = 0
    var switchToAllSchoolButton: UIButton
    var switchToGroupButtons: [UIButton]
    var allSchoolButtonLayer: CALayer!
    var groupButtonLayer: [CALayer] = []
    
    init(switchToAllSchoolButton: UIButton, switchToGroupButtons: [UIButton]) {
        self.switchToAllSchoolButton = switchToAllSchoolButton
        self.switchToGroupButtons = switchToGroupButtons
        
        self.allSchoolButtonLayer = CALayer()
        self.initialUnderlineLayer(button: switchToAllSchoolButton, layer: allSchoolButtonLayer)
        for i in 1...20 {
            groupButtonLayer.append(CALayer())
            self.initialUnderlineLayer(button: switchToGroupButtons[i-1], layer: groupButtonLayer[i-1])
        }
        self.switchToAllSchool()
    }
    
    func initialUnderlineLayer(button: UIButton, layer: CALayer) {
        layer.frame = CGRect(x: 0, y: button.frame.height, width: button.frame.width, height: 2)
        layer.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
    }
    
    func setAllBaseStyle() {
        self.allSchoolButtonLayer.removeFromSuperlayer()
        for i in 1...20 {
            groupButtonLayer[i-1].removeFromSuperlayer()
        }
    }
    
    func switchToAllSchool() {
        self.currentIndex = 0
        self.setAllBaseStyle()
        self.switchToAllSchoolButton.layer.addSublayer(allSchoolButtonLayer)
    }
    
    func switchToGroup(groupNumber: Int) {
        self.currentIndex = groupNumber
        let index = groupNumber - 1
        self.setAllBaseStyle()
        self.switchToGroupButtons[index].layer.addSublayer(groupButtonLayer[index])
    }
    
    func switchToRight() -> Bool {
        if (currentIndex == 0) {
            return false
        }
        currentIndex -= 1
        if (currentIndex == 0) {
            switchToAllSchool()
        } else {
            switchToGroup(groupNumber: currentIndex)
        }
        return true
    }
    
    func switchToLeft() -> Bool {
        if (currentIndex == 20) {
            return false
        }
        currentIndex += 1
        if (currentIndex == 0) {
            switchToAllSchool()
        } else {
            switchToGroup(groupNumber: currentIndex)
        }
        return true
    }
}
