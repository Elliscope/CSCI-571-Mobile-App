//
//  LegislatorCustomeCell.swift
//  SlideMenuControllerSwift
//
//  Created by Elliscope Mingzhe Fang on 11/29/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class LegislatorCustomeCell: UITableViewCell {

    @IBOutlet weak var pro_img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var state: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
