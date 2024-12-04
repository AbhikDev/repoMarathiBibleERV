
import UIKit
import SideMenu

/**
 This class is used to represent header for whole project
*/

enum HEADER_TYPE:Int {
    case menu = 0
    case back
    
    
    func getImage() -> UIImage {
        switch self {
        case .menu:
            return  UIImage.init(named: "menu")!
        case .back:
            return UIImage.init(named: "backIcon")!
        
        }
    }
}

class CustomNavigationView: UIView {
    @IBOutlet fileprivate var view:UIView!
   
    @IBOutlet weak var bacKVWWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    
    internal var headerType:HEADER_TYPE = .menu {
        didSet{
            self.imgLeft.image = headerType.getImage()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func setup() {
        if let view = Bundle.main.loadNibNamed("CustomNavigationView", owner: self, options: nil)?.first as? UIView {
            self.view = view
            self.view.frame = self.bounds
            
            self.addSubview(self.view)
        }
    }
}
extension CustomNavigationView{
    @IBAction func leftButtonPressed(_ btn:UIButton) {
        
        
        if self.headerType == .menu {
            self.menuPressed()
        }
        else{
            self.backPressed()
        }
    }
    @IBAction func backPressed() {
        appDel.topViewControllerWithRootViewController(rootViewController: MyBasics.getMyKeyWindow()?.rootViewController)?.view.endEditing(true)
        
        appDel.topViewControllerWithRootViewController(rootViewController: MyBasics.getMyKeyWindow()?.rootViewController)?.navigationController?.popViewController(animated: true)
        appDel.topViewControllerWithRootViewController(rootViewController: MyBasics.getMyKeyWindow()?.rootViewController)?.dismiss(animated: true)
    }
    private func menuPressed(){
        
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        
        SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle = .menuSlideIn
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menu = storyboard.instantiateViewController(withIdentifier: "SideMenuNavigationController") as! SideMenuNavigationController
        menu.leftSide = true
        
        UIApplication.shared.windows.first?.rootViewController?.present(menu, animated: true, completion: nil)
    }
    
    
}
