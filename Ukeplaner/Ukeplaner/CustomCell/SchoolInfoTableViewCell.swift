//
//  SchoolInfoTableViewCell.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 13/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class SchoolInfoTableViewCell: UITableViewCell {

    @IBOutlet var schoolInfoTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(schoolinfo : String)
    {
        self.schoolInfoTitle.textColor = TextColor
        self.schoolInfoTitle.text = schoolinfo
        self.schoolInfoTitle.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
