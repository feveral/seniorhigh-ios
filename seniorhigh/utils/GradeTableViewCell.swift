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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
