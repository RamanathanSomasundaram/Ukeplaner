//
//  GroupInfoCollectionViewCell.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/02/18.
//  Copyright © 2018 lakeba. All rights reserved.
//

import UIKit

class GroupInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var lbl_groupName: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet var collectionViewCellWidth: NSLayoutConstraint!
    let screenWidth = (UIScreen.main.bounds.size.width - 4) / 2
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setupCollectionViewCell(dicValues : NSDictionary)
    {
        Utilities.makeCardView(self.bgView)
        self.backgroundColor = UIColor.lightGray
        self.lbl_groupName.textColor = TextColor
        self.lbl_groupName.text = (dicValues.value(forKey: "group_name") as! String)
    }
    
}
