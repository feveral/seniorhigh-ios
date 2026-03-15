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
    private var buttons: [UIButton]
    
    init(switchToAllSchoolButton: UIButton, switchToFirstGroupButton: UIButton, switchToSecondGroupButton: UIButton, switchToThirdGroupButton: UIButton) {
        self.buttons = [switchToAllSchoolButton, switchToFirstGroupButton, switchToSecondGroupButton, switchToThirdGroupButton]
        self.buttons.forEach { Theme.styleFilterChip($0, isSelected: false) }
        self.switchToAllSchool()
    }
    
    func switchToAllSchool() {
        self.currentIndex = 0
        updateAppearance()
    }
    
    func switchToGroup(groupNumber: Int) {
        self.currentIndex = groupNumber
        updateAppearance()
    }
    
    func switchToRight() -> Bool {
        if (currentIndex == 0) {
            return false
        }
        currentIndex -= 1
        updateAppearance()
        return true
    }
    
    func switchToLeft() -> Bool {
        if (currentIndex == 3) {
            return false
        }
        currentIndex += 1
        updateAppearance()
        return true
    }

    private func updateAppearance() {
        for (index, button) in buttons.enumerated() {
            Theme.styleFilterChip(button, isSelected: currentIndex == index)
        }
    }
}
