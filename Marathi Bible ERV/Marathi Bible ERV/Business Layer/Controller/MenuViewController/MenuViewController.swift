
import UIKit
import SideMenu


class MenuViewController: BaseViewController {
    
    @IBOutlet weak var menuTable: UITableView!
    
    var menuName = ["Home","Privacy Policy","Day night","Settings","Rate Us","About Marathi Bible ERV"]
    
    let imageArray = ["home","privacy","dayNight","settings","rate","about"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTable.contentInset =  UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0);
        menuTable.rowHeight =  UITableView.automaticDimension
        menuTable.estimatedRowHeight = 100
        menuTable.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuTable.beginUpdates()
        menuTable.setNeedsDisplay()
        menuTable.endUpdates()
    }
}

//Mark: - TableView Extention
extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1: menuName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        switch(index) {
        case 0  :
            let cell: MenuTableViewCell = self.menuTable.dequeueReusableCell(withIdentifier: "cellMenuHeader") as! MenuTableViewCell
            cell.populateMenuTable(name: App_Title,imageName:"AppLogo")
            cell.menuImage.layer.cornerRadius = 40
            cell.leadConstraintMenuImage?.constant = self.view.frame.size.width / 2 - 40
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
        case 1  :
            let cell: MenuTableViewCell = self.menuTable.dequeueReusableCell(withIdentifier: "cellMenu") as! MenuTableViewCell
            cell.populateMenuTable(name: menuName[indexPath.row],imageName:imageArray[indexPath.row ],isLightThemeShouldTaken: true)
            cell.selectionStyle = .none
            return cell
        default :
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let index = indexPath.row
            switch(index) {
            case 0  :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
                self.navigationController?.pushViewController(vc,animated: true)
                break
            case 1  :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BibleCMS") as! BibleCMS
                vc.headerText = "Privacy Policy"
                vc.urlToLoad = privacyPolicy
                self.navigationController?.pushViewController(vc,animated: true)
                break
            case 2 :
                let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
                if isDarkModeON {
                    changeTheme(themeVal: "light")
                }else{
                    changeTheme(themeVal: "dark")
                }
                
                UserDefaults.standard.set(!isDarkModeON, forKey: APP_THEME_MODE)
                self.menuTable.reloadData()
                break
            case 3 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AppSettingsVC") as! AppSettingsVC
                self.navigationController?.pushViewController(vc,animated: true)
                break
                
            case 4 :
                let appID = "id6739004981"
                let urlStr = "https://itunes.apple.com/app/\(appID)?action=write-review"
                guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url) 
                }
                break
            case 5 :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BibleCMS") as! BibleCMS
                vc.headerText = "About Us"
                vc.urlToLoad = aboutUs
                self.navigationController?.pushViewController(vc,animated: true)
                break
            default:
                break
                
            }
        }
    }
    func navigationToHomeScreen(){
        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
            navigationController?.pushViewController(vc,animated: true)
        }
    }
    func uiUpdationOnHomeScreen(){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
                if(vc == topController){
                    print("Bingo!!!!!!!!")
                }
            }
            
            // topController should now be your topmost view controller
        }
    }
}
extension MenuViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        debugPrint("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        debugPrint("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        debugPrint("SideMenu Disappearing! (animated: \(animated))")
    }
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        debugPrint("SideMenu Disappeared! (animated: \(animated))")
    }
    
}
