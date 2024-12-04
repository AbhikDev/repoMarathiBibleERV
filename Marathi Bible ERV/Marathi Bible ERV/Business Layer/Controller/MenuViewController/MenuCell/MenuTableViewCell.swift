
import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuImgContainer: UIView!
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var menuName: UILabel!
    
    @IBOutlet weak var leadConstraintMenuImage: NSLayoutConstraint?
    @IBOutlet weak var menuImageXLayoutConstraint: NSLayoutConstraint!
    func populateMenuTable(name:String,imageName:String,isLightThemeShouldTaken:Bool = false) {
        menuName.text = name
        menuImage.image = UIImage(named: imageName)
        if isLightThemeShouldTaken{
            let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
            menuImage.tintColor = isDarkModeON ? .white : UIColor(named: "AppTextColor")!
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
