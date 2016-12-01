//
//  SubContents/Users/Elliscope/Documents/Developer/IOS/CSCI-571-Mobile-App/SlideMenuControllerSwift-master/SlideMenuControllerSwiftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubContentsViewController : UIViewController {
    var bioguide_id = ""
    var img_url = ""
    var first_name = ""
    var last_name = ""
    var state_name = ""
    var birth_date = ""
    var gender = ""
    var chamber = ""
    var fax_num = ""
    var twitter_link = ""
    var fb_link = ""
    var web_link = ""
    var office_num = ""
    var term_ends = ""
    
    @IBOutlet weak var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.text.text = bioguide_id
    }
}
