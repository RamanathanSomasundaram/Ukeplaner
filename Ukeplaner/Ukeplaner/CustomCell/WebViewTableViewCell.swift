//
//  WebViewTableViewCell.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 13/09/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class WebViewTableViewCell: UITableViewCell {

    @IBOutlet var webViewContent: UIWebView!
    @IBOutlet var contentSize: NSLayoutConstraint!    
    @IBOutlet var teacherName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
