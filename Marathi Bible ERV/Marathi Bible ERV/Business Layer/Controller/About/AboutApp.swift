
import UIKit

class AboutApp: BaseViewController {

    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var imgVW: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigation.lblHeader.text = "About App"
        customNavigation.headerType = .back
        // Do any additional setup after loading the view.
        
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject?

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let versionStr = nsObject as! String
        version.text = "VERSION \(versionStr)"
    }
    
}
