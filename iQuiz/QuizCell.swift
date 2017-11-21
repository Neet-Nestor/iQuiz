//
//  QuizCell.swift
//  iQuiz
//
//  Created by Nestor Qin on 11/5/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class QuizCell: UITableViewCell {
    
    // Mark: Properties
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descrip: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
