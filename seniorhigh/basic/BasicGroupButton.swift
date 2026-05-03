//
//  BasicGroupButton.swift
//  seniorhigh
//

import UIKit

class BasicGroupButton {

    var currentIndex: Int = 0
    private var buttons: [UIButton]

    init(switchToAllSchoolButton: UIButton, switchToFirstGroupButton: UIButton, switchToSecondGroupButton: UIButton) {
        self.buttons = [switchToAllSchoolButton, switchToFirstGroupButton, switchToSecondGroupButton]
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
        if currentIndex == 0 { return false }
        currentIndex -= 1
        updateAppearance()
        return true
    }

    func switchToLeft() -> Bool {
        if currentIndex == 2 { return false }
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
