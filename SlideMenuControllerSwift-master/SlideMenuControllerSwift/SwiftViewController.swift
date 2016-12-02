//
//  SwiftViewController.swift
//  SlideMenuControllerSwift
//

//



import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class SwiftViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var BillTableView: UITableView!
    var data:[JSON] = []
    let arrIndexSection = ["A","B","C","D", "E", "F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var section_size = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var state_index_dic:[Character:Int] = ["A":0,"B":1,"C":2,"D":3, "E":4, "F":5,"G":6,"H":7,"I":8,"J":9,"K":10,"L":11,"M":12,"N":13,"O":14,"P":15,"Q":16,"R":17,"S":18,"T":19,"U":20,"V":21,"W":22,"X":23,"Y":24,"Z":25 ]
    var state_to_index_dic:[Int:Character] = [0:"A",1:"B",2:"C",3:"D", 4:"E", 5:"F",6:"G",7:"H",8:"I",9:"J",10:"K",11:"L",12:"M",13:"N",14:"O",15:"P",16:"Q",17:"R",18:"S",19:"T",20:"U",21:"V",22:"W",23:"X",24:"Y",25:"Z" ]
    
    var dataDict = [String:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BillTableView.registerCellNib(DataTableViewCell.self)
        SwiftSpinner.show("Fetching Data...")
        loadingData(url: "http://104.198.0.197:8080/bills?per_page=50&history.active=true&order=introduced_on__desc&last_version.urls.pdf__exists=true")
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
            loadingData(url: "http://104.198.0.197:8080/bills?per_page=50&history.active=true&order=introduced_on__desc&last_version.urls.pdf__exists=true")
            searchEngineURLString = "https://www.bing.com"
            print(searchEngineURLString)
            break
        case 1:
            SwiftSpinner.show("Fetching Data...")
            loadingData(url: "http://104.198.0.197:8080/bills?per_page=50&history.active=false&order=introduced_on__desc&last_version.urls.pdf__exists=true")
            searchEngineURLString = "https://www.duckduckgo.com"
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
            self.BillTableView?.reloadData()
            DispatchQueue.main.async {
                SwiftSpinner.hide()
            }
            
        }
    }
}

extension SwiftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
//        return 10
    }
    
    
    //    the part of code that navigates towards to the subcontentViewController. Need to pass in parameters.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension SwiftViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! BillTableViewCell

        cell.BillLabel.text = self.data[indexPath.row]["bill_id"].string!
        cell.BillTextField.text = self.data[indexPath.row]["official_title"].string!

        return cell
    }
}
