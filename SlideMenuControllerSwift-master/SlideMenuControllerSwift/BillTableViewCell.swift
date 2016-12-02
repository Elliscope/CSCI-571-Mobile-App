//
//  BillTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Elliscope Mingzhe Fang on 12/1/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    @IBOutlet weak var BillTextField: UITextView!
    @IBOutlet weak var BillLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
