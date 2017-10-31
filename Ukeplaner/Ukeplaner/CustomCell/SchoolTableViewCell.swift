//
//  SchoolTableViewCell.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 05/09/17.
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
    func configureCell (dictValues : NSDictionary)
    {
        let image : UIImage = UIImage(named: "sampleImage.png")!
        self.schoolLogo.sd_setShowActivityIndicatorView(true)
        self.schoolLogo.sd_setIndicatorStyle(.gray)
        self.schoolLogo.sd_setImage(with: URL(string: (dictValues.value(forKey: "school_logo")! as! String))! , placeholderImage: image, options: .refreshCached)
        self.schoolLogo.image = image
        self.schoolName.text = (dictValues.value(forKey: "school_name") as! String)
        self.schoolEmailID.text = (dictValues.value(forKey: "school_email") as! String)
        self.schoolPhoneNo.text = "Tlf : \(dictValues.value(forKey: "phone_number") as! String)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
