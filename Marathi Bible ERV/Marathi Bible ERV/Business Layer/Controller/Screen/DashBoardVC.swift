
import UIKit

class DashBoardVC: BaseViewController {
    
    @IBOutlet weak var tblDashBoard: UITableView!
    
    @IBOutlet weak var btnOldT: UIButton!
    @IBOutlet weak var btnNewT: UIButton!
    var isSelectOldTestement = false
    
    var allstories:[ModelStoryList] = []
    var filterStories:[ModelStoryList] = []
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var lblNoData: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigation.lblHeader.text = "\(App_Title ?? "पवित्र बायबल")"
        customNavigation.headerType = .menu
        // Do any additional setup after loading the view.
        fetchStoryList()
        setupPullTorefresh()
    }
    func setupPullTorefresh(){
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblDashBoard.addSubview(refreshControl)
        tblDashBoard.rowHeight = 160
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        allstories.removeAll()
        callStoryListData(selectedLanguageId: appLanguageCode)
        self.refreshControl.endRefreshing()
    }
    func fetchStoryList(){
        if let storyList = fetchAllStories(),storyList.count > 0{
            allstories = storyList
            defaultselectionOfTestement()
        }else{
            callStoryListData(selectedLanguageId: appLanguageCode)
        }
    }
}
extension DashBoardVC{
    @IBAction func selectionofOldTestament(_ sender:UIButton){
        defaultselectionOfTestement()
    }
    @IBAction func selectionofNewTestament(_ sender:UIButton){
        
        btnOldT.backgroundColor = UIColor(named: "AppFadeColor")!
        btnOldT.setTitleColor(.black, for: .normal)
        
        btnNewT.backgroundColor = UIColor(named: "AppBGColorLight")!
        btnNewT.setTitleColor(.white, for: .normal)
        isSelectOldTestement = false
        filterofTestament(filtertype: "NT")
        
    }
    func defaultselectionOfTestement(){
        isSelectOldTestement = true
        btnOldT.backgroundColor = UIColor(named: "AppBGColorLight")!
        btnOldT.setTitleColor(.white, for: .normal)
        
        btnNewT.backgroundColor = UIColor(named: "AppFadeColor")!
        btnNewT.setTitleColor(.black, for: .normal)
        filterofTestament(filtertype: "OT")
    }
    
    func filterofTestament(filtertype type:String){
        filterStories = allstories.filter({$0.type == type })
        filterStories = filterStories.sorted {
            $0.sequence < $1.sequence
        }
        tblDashBoard.isHidden = !(filterStories.count > 0)
        tblDashBoard.reloadData()
    }
}
//Mark: - TableView Extention
extension DashBoardVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterStories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CommonCellTableViewCell = self.tblDashBoard.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell") as! CommonCellTableViewCell
        
        let obj = filterStories[indexPath.row]
      
        cell.lblInfo.text = "[\(obj.sequence)] " + obj.shortName + " [\(obj.code)] "
        
        cell.selectionStyle = .none
        cell.vwContainer1.backgroundColor = .clear
        cell.btnInstance1.layer.cornerRadius = 10
        cell.btnInstance2.layer.cornerRadius = 10
       
        cell.btn1Protocol = self
        cell.btn2Protocol = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "StoryDetails") as! StoryDetails
             vc.selectedStoryFromList = filterStories[indexPath.row]
             vc.isSelectOldTestement = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StoryDetails") as! StoryDetails
            vc.selectedStoryFromList = filterStories[indexPath.row]
            vc.isSelectOldTestement = false
            navigationController?.pushViewController(vc,animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

//MARK: TABLE CELL DELEGATE CALL
extension DashBoardVC :ButtonInstance1Delegate{
    func selectedButton1Instance(cell: UITableViewCell) {
        if let indexPath = tblDashBoard.indexPath(for: cell) {
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "AudioStoryList") as! AudioStoryList
                vc.selectedStoryFromList = filterStories[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AudioStoryList") as! AudioStoryList
                vc.selectedStoryFromList = filterStories[indexPath.row]
                navigationController?.pushViewController(vc,animated: true)
            }
        }
    }
}
extension DashBoardVC :ButtonInstance2Delegate{
    func selectedButton2Instance(cell: UITableViewCell) {
        if let indexPath = tblDashBoard.indexPath(for: cell) {
            if #available(iOS 13.0, *) {
               let vc = self.storyboard?.instantiateViewController(identifier: "StoryDetails") as! StoryDetails
                vc.selectedStoryFromList = filterStories[indexPath.row]
                vc.isSelectOldTestement = false
               self.navigationController?.pushViewController(vc, animated: true)
           } else {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "StoryDetails") as! StoryDetails
               vc.selectedStoryFromList = filterStories[indexPath.row]
               vc.isSelectOldTestement = false
               navigationController?.pushViewController(vc,animated: true)
           }
        }
    }
}
//MARK: API CALL
extension DashBoardVC {
    
    func callStoryListData(selectedLanguageId:String){
        guard let reachInternet = Reachability(hostName: "https://www.google.co.in/") , reachInternet.isReachable == true else{
            self.view.makeToast(NETWORK_NOT_REACHABLE)
            return
        }
        guard let baseUrl = API.story_list.getURL()?.absoluteString else{return}
        let url_str = ( baseUrl + selectedLanguageId + "/story")
        let operation = WebServiceOperation.init(url_str, nil, .WEB_SERVICE_GET, nil)
        operation.completionBlock = {
            DispatchQueue.main.async {
                guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                    self.filterofTestament(filtertype: (self.isSelectOldTestement ? "OT" : "NT"))
                    return
                }
                do{
                    
                    if let status = dictResponse["status"] as? Int , status == 200{
                        if let dictData = dictResponse["data"]  as? [[String:Any]] , dictData.count > 0, let storyListData = dictData.data{
                            self.allstories.removeAll()
                            let arrStoryList = try JSONDecoder().decode([ModelStoryList].self, from: dictData.data!)
                            self.allstories = arrStoryList
                            self.filterStories = self.allstories
                            self.insertAllStoryList(allStoryData: storyListData)
                            self.defaultselectionOfTestement()
                        }else{
                            showAlertMessage(title: App_Title, message: NO_DATA, vc: self)
                        }
                    }else{
                        showAlertMessage(title: App_Title, message: NO_DATA, vc: self)
                    }
                    self.filterofTestament(filtertype: (self.isSelectOldTestement ? "OT" : "NT"))
                }catch {
                    self.filterofTestament(filtertype: (self.isSelectOldTestement ? "OT" : "NT"))
                    showAlertMessage(title: App_Title, message: SOME_ERROR, vc: self)
                }
            }
        }
        appDel.operationQueue.addOperation(operation)
    }
}
