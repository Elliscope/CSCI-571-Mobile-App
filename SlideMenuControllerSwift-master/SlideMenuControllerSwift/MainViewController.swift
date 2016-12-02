//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class MainViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var data:[JSON] = []
    let arrIndexSection = ["A","B","C","D", "E", "F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var section_size = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var state_index_dic:[Character:Int] = ["A":0,"B":1,"C":2,"D":3, "E":4, "F":5,"G":6,"H":7,"I":8,"J":9,"K":10,"L":11,"M":12,"N":13,"O":14,"P":15,"Q":16,"R":17,"S":18,"T":19,"U":20,"V":21,"W":22,"X":23,"Y":24,"Z":25 ]
    var state_to_index_dic:[Int:Character] = [0:"A",1:"B",2:"C",3:"D", 4:"E", 5:"F",6:"G",7:"H",8:"I",9:"J",10:"K",11:"L",12:"M",13:"N",14:"O",15:"P",16:"Q",17:"R",18:"S",19:"T",20:"U",21:"V",22:"W",23:"X",24:"Y",25:"Z" ]
    
    var dataDict = [String:[String]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)
        SwiftSpinner.show("Fetching Data...")
        loadingData(url: "https://congress.api.sunlightfoundation.com/legislators?per_page=all&order=state__asc")
        //code the change font size of the Tab Text
        
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
            SwiftSpinner.show("Fetching Data...")
            loadingData(url: "https://congress.api.sunlightfoundation.com/legislators?per_page=all&order=state__asc,last_name_asc")
            searchEngineURLString = "https://www.bing.com"
            print(searchEngineURLString)
            break
        case 1:
            SwiftSpinner.show("Fetching Data...")
            loadingData(url: "https://congress.api.sunlightfoundation.com/legislators?chamber=senate&per_page=all&order=last_name__asc")
            searchEngineURLString = "https://www.duckduckgo.com"
            print(searchEngineURLString)
            break
        case 2:
            SwiftSpinner.show("Fetching Data...")
            loadingData(url: "https://congress.api.sunlightfoundation.com/legislators?chamber=house&per_page=all&order=last_name__asc")
            searchEngineURLString = "https://www.google.com"
            print(searchEngineURLString)
            break
        default:
            SwiftSpinner.show("Fetching Data...")
            searchEngineURLString = "https://www.des.com"
            print(searchEngineURLString)
            break
        }
        

    }
 
    func loadingData(url: String!) {
        Alamofire.request(url).responseJSON { response in
            let json = JSON(response.result.value!)
            self.data = json["results"].arrayValue
            var loop_iterator = 0
            let data_length =  self.data.count
            self.section_size = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            
            while loop_iterator < data_length{
                let state_n = self.data[loop_iterator]["state_name"].string!
                let first_char = state_n[state_n.startIndex]
                let index = self.state_index_dic[first_char]!
                self.section_size[index] += 1
                let key = "\(state_n[state_n.startIndex])"
                //append the state name to the corresponding section
                if var stateValues = self.dataDict[key]{
                    stateValues.append(state_n)
                    self.dataDict[key]=stateValues
                } else{
                    self.dataDict[key] = [state_n]
                }
                loop_iterator += 1
            }
            self.tableView?.reloadData()
            DispatchQueue.main.async {
                SwiftSpinner.hide()
            }
            
        }
    }
}


extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
    
    
//    the part of code that navigates towards to the subcontentViewController. Need to pass in parameters.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
        
//        _ = tableView.indexPathForSelectedRow!
//        if let _ = tableView.cellForRow(at: indexPath) {
//            let data_string = self.data[indexPath.row]["state_name"].string!
//            self.performSegue(withIdentifier: "SendDataSegue", sender: data_string)
//        }
        
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SendDataSegue" {
//            if let destination = segue.destination as? LegislatorDetailsTableViewController {
////                let path = tableView.indexPathForSelectedRow
////                let cell = tableView.cellForRow(at: path!) as! LegislatorCustomeCell
////                destination.viaSegue = (cell.state.text!)
//                destination.viaSegue = sender as! String
//            }
//        }
//    }
   }

extension MainViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.section_size.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section_size[section]
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! LegislatorCustomeCell
        
        var s = 0;
        let limit = indexPath.section
        var counter = 0
        print(indexPath)
        
        while s < limit{
            counter = counter + self.section_size[s]
            s += 1
        }
        cell.name.text = self.data[counter+indexPath.row]["first_name"].string! + " " + self.data[counter+indexPath.row]["last_name"].string!
        cell.state.text = self.data[counter+indexPath.row]["state_name"].string!
        
        
        let img_url = "https://theunitedstates.io/images/congress/original/"+self.data[counter+indexPath.row]["bioguide_id"].string!+".jpg"
        let url = URL(string: img_url)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if(data != nil){
                    cell.pro_img.image = UIImage(data: data!)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.section_size[section]==0){
            return ""
        }
        return String(describing: self.state_to_index_dic[section]!)
    }
    
   func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.arrIndexSection
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
