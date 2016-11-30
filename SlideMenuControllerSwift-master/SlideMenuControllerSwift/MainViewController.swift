//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var data:[JSON] = []
    let arrIndexSection = ["A","B","C","D", "E", "F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var section_size = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var state_index_dic:[Character:Int] = ["A":0,"B":1,"C":2,"D":3, "E":4, "F":5,"G":6,"H":7,"I":8,"J":9,"K":10,"L":11,"M":12,"N":13,"O":14,"P":15,"Q":16,"R":17,"S":18,"T":19,"U":20,"V":21,"W":22,"X":23,"Y":24,"Z":25 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
        Alamofire.request("https://congress.api.sunlightfoundation.com/legislators?order=state__asc&per_page=all").responseJSON { response in
            let json = JSON(response.result.value!)
            self.data = json["results"].arrayValue
            print(self.data)
            
            var loop_iterator = 0
            let data_length =  self.data.count
            
            while loop_iterator < data_length{
                
                let state_n = self.data[loop_iterator]["state_name"].string!
                let first_char = state_n[state_n.startIndex]
                let index = self.state_index_dic[first_char]!
                self.section_size[index] += 1
                loop_iterator += 1
            }
            print(self.section_size)
            self.tableView?.reloadData()
        }
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "Arial", size: 22)!]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var searchEngineURLString: NSString! = "";
        
        switch item.tag  {
        case 0:
            searchEngineURLString = "https://www.bing.com"
            print(searchEngineURLString)
            break
        case 1:
            searchEngineURLString = "https://www.duckduckgo.com"
            print(searchEngineURLString)
            break
        case 2:
            searchEngineURLString = "https://www.google.com"
            print(searchEngineURLString)
            break
        default:
            searchEngineURLString = "https://www.des.com"
            print(searchEngineURLString)
            break
        }
        
//        loadSearchEngine(searchEngineURLString);
    }
//    
//    func loadSearchEngine(searchEngineURLString: NSString!) {
//        var searchEngineURL = NSURL(string: searchEngineURLString)
//        var searchEngineURLRequest = NSURLRequest(URL: searchEngineURL)
//        webView.loadRequest(searchEngineURLRequest)
//    }
}


extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
    
    
    
    //the part of code that navigates towards to the subcontentViewController. Need to pass in parameters.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension MainViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 26
    }
    
    
//    func tableView(_ tableView: UITableView,titleForHeaderInSection section: Int) -> String?{
//        
//        return
//    }
//    
//    func tableView(_ tableView: UITableView,sectionForSectionIndexTitle title: String,at index: Int) -> Int{
//        
//        return
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! LegislatorCustomeCell

        cell.name.text = self.data[indexPath.row]["first_name"].string! + " " + self.data[indexPath.row]["last_name"].string!
        cell.state.text = self.data[indexPath.row]["state_name"].string!
        
        
        let img_url = "https://theunitedstates.io/images/congress/original/"+self.data[indexPath.row]["bioguide_id"].string!+".jpg"
        let url = URL(string: img_url)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                if(data != nil){
                    cell.pro_img.image = UIImage(data: data!)
                }
            }
        }
        
        return cell
    }
}

extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
}


//extension String {
//    
//    var length: Int {
//        return self.characters.count
//    }
//    
//    subscript (r: Range<Int>) -> String {
//        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
//                                            upper: min(length, max(0, r.upperBound))))
//        let start = index(startIndex, offsetBy: range.lowerBound)
//        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
//        return self[Range(start ..< end)]
//    }
//    
//    subscript (i: Int) -> String {
//        return self[Range(i ..< i + 1)]
//    }
//    
//    func substring(from: Int) -> String {
//        return self[Range(min(from, length) ..< length)]
//    }
//    
//    func substring(to: Int) -> String {
//        return self[Range(0 ..< max(0, to))]
//    }
//}
