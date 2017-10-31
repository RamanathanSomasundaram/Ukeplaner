//
//  WeekTimeTableViewCell.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 06/09/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class WeekTimeTableViewCell: UITableViewCell {
    
    @IBOutlet var subjectName: UILabel!
    @IBOutlet var subjectDesc: UILabel!
    @IBOutlet var weekBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subjectName.layer.masksToBounds = true
        self.subjectName.layer.cornerRadius = 5
        // Initialization code
    }
    func configureCell(dictValues : NSDictionary)
    {
        self.subjectName.text = (dictValues.value(forKey: "subject_name") as! String)
        self.subjectName.layer.masksToBounds = true
        self.subjectName.layer.cornerRadius = 5
        self.subjectDesc.text = (dictValues.value(forKey: "description") as! String)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
