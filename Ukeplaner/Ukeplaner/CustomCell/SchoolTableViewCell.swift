//
//  SchoolTableViewCell.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    @IBOutlet var schoolLogo: UIImageView!
    @IBOutlet var schoolName: UILabel!
    @IBOutlet var schoolEmailID: UILabel!
    @IBOutlet var schoolPhoneNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
