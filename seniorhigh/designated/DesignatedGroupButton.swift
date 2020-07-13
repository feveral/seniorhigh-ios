//
//  designatedGroupButtonStatus.swift
//  seniorhigh
//
//  Created by 楊宗翰 on 2019/8/1.
//  Copyright © 2019 楊宗翰. All rights reserved.
//

import UIKit

class DesignatedGroupButton {
    
    var currentIndex: Int  = 0
    var switchToAllSchoolButton: UIButton
    var switchToFirstGroupButton: UIButton
    var switchToSecondGroupButton: UIButton
    var switchToThirdGroupButton: UIButton
    var allSchoolButtonLayer: CALayer!
    var firstGroupButtonLayer: CALayer!
    var secondGroupButtonLayer: CALayer!
    var thirdGroupButtonLayer: CALayer!
    
    init(switchToAllSchoolButton: UIButton, switchToFirstGroupButton: UIButton, switchToSecondGroupButton: UIButton, switchToThirdGroupButton: UIButton) {
        self.switchToAllSchoolButton = switchToAllSchoolButton
        self.switchToFirstGroupButton = switchToFirstGroupButton
        self.switchToSecondGroupButton = switchToSecondGroupButton
        self.switchToThirdGroupButton = switchToThirdGroupButton
        
        self.allSchoolButtonLayer = CALayer()
        self.firstGroupButtonLayer = CALayer()
        self.secondGroupButtonLayer = CALayer()
        self.thirdGroupButtonLayer = CALayer()
        
        self.allSchoolButtonLayer.frame = CGRect(x: 0, y: switchToAllSchoolButton.frame.height, width: switchToAllSchoolButton.frame.width, height: 2)
        self.allSchoolButtonLayer.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        
        self.firstGroupButtonLayer.frame = CGRect(x: 0, y: switchToFirstGroupButton.frame.height, width: switchToFirstGroupButton.frame.width, height: 2)
        self.firstGroupButtonLayer.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)

        self.firstGroupButtonLayer.frame = CGRect(x: 0, y: switchToFirstGroupButton.frame.height, width: switchToFirstGroupButton.frame.width, height: 2)
        self.firstGroupButtonLayer.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        
        self.secondGroupButtonLayer.frame = CGRect(x: 0, y: switchToSecondGroupButton.frame.height, width: switchToSecondGroupButton.frame.width, height: 2)
        self.secondGroupButtonLayer.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        
        self.thirdGroupButtonLayer.frame = CGRect(x: 0, y: switchToThirdGroupButton.frame.height, width: switchToThirdGroupButton.frame.width, height: 2)
        self.thirdGroupButtonLayer.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        self.switchToAllSchool()
    }
    
    func setAllBaseStyle() {
        self.allSchoolButtonLayer.removeFromSuperlayer()
        self.firstGroupButtonLayer.removeFromSuperlayer()
        self.secondGroupButtonLayer.removeFromSuperlayer()
        self.thirdGroupButtonLayer.removeFromSuperlayer()
    }
    
    func switchToAllSchool() {
        self.currentIndex = 0
        self.setAllBaseStyle()
        self.switchToAllSchoolButton.layer.addSublayer(allSchoolButtonLayer)
    }
    
    func switchToGroup(groupNumber: Int) {
        self.currentIndex = groupNumber
        self.setAllBaseStyle()
        if (groupNumber == 1) {
            self.switchToFirstGroupButton.layer.addSublayer(firstGroupButtonLayer)
        } else if (groupNumber == 2) {
            self.switchToSecondGroupButton.layer.addSublayer(secondGroupButtonLayer)
        } else if (groupNumber == 3) {
            self.switchToThirdGroupButton.layer.addSublayer(thirdGroupButtonLayer)
        }
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
        if (currentIndex == 3) {
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
