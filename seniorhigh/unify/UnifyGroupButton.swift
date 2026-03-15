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
    private var buttons: [UIButton]
    private let maxIndex: Int
    
    init(switchToAllSchoolButton: UIButton, switchToGroupButtons: [UIButton]) {
        self.buttons = [switchToAllSchoolButton] + switchToGroupButtons
        self.maxIndex = self.buttons.count - 1
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
        if (currentIndex == maxIndex) {
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
