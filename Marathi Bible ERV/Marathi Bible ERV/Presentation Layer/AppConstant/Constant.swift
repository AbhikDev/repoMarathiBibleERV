

import Foundation
import UIKit


let App_Title:String! = "पवित्र बायबल"
//MARK : AppDelegate instant
let appDel = UIApplication.shared.delegate as! AppDelegate
var fixedFont:Float = 13
let appLanguageCode = "mr"
let appChapterHeader="अध्याय"
let deviceBounds:CGRect! = UIScreen.main.bounds
var selectedAudioIndex = NSNotFound
var selectedAudioProperty: SelectedAudioObject!
let privacyPolicy = "https://sites.google.com/view/wbrtc-bible/privacy-policy"
let aboutUs = "https://sites.google.com/view/wbrtc-bible/about"
///Mark: API
let BaseUrl:String  = "https://erv.wbtcindia.in"//"http://3.17.107.226"//"https://wbtcirevisederv.herokuapp.com"
let APP_KEY_ALL_STORY = "APP_KEY_ALL_STORY"
let APP_KEY_STORY_DETAILS = "APP_KEY_STORY_DETAILS"
let APP_KEY_AUDIO_LIST = "APP_KEY_AUDIO_LIST"
let APP_THEME_MODE = "APP_THEME_MODE"
let APP_SELECTED_AUDIO_INDEX = "APP_SELECTED_AUDIO_INDEX"
//Mark : Api Url
public enum API:Int {
    case language_list
    case story_list
    case story
    case audio_list
    case cotentDetails
    
    func getURL() -> URL? {
        switch self {
            
        case .language_list:
            return URL.init(string: (BaseUrl+"/bibleapp/api/language"))
        case .story_list:
            return URL.init(string: (BaseUrl+"/api/v1/"))
        case .story:
            return URL.init(string: (BaseUrl+"/api/v1/"))
        case .audio_list:
            return URL.init(string: (BaseUrl+"/api/v1/"))
        case .cotentDetails:
            return URL.init(string: (BaseUrl+"/bibleapp/api/content-details/"))
        }
    }
}



var shadowView = UIView()
var listV = ListPickerView()
class MyBasics: NSObject {
    
    class func getMyKeyWindow() -> UIWindow?{
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
           return keyWindow
        } else {
            
            return UIApplication.shared.keyWindow
        }
        
    }
    
    // MARK: List picker
    
    class func showListDropDown(Items:Array<String>, ParentViewC:UIViewController) {
        
        shadowView = UIView(frame: deviceBounds)
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.0
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideListView))
        tapGes.numberOfTapsRequired = 1
        shadowView.addGestureRecognizer(tapGes)
        listV = Bundle.main.loadNibNamed("ListPickerView", owner: ParentViewC, options: nil)?.first as! ListPickerView
        listV.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
        ParentViewC.view.addSubview(shadowView)
        ParentViewC.view.addSubview(listV)
        ParentViewC.view.endEditing(true)
        listV.myDelegate = ParentViewC as? CustomListDelegate
        listV.ReloadPickerView(dataArray: Items)
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.3
            listV.frame = CGRect(x: 0, y: deviceBounds.size.height - 227.0, width: deviceBounds.size.width, height: 227.0)
            
        }, completion: nil)
        
    }
    
    @objc class func hideListView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.0
            listV.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
            
        }) { (Bool) in
            
            //listV.myDelegate?.ListDidHide!()
            shadowView.removeFromSuperview()
            listV.removeFromSuperview()
            
        }
    }
    
}
struct SelectedAudioObject {
    var selectedAudioIndex = NSNotFound
    var selectedAudioStory : String//Story
    var selectedChapter:String//Chapter
    var selectedAudioUrl,propertyAlbumTitle,propertyTitle :String
    var isSelectRepeat,isSelectShuffle:Bool
    
}
struct PreviouslySelectedChapter{
    let shortName, longName, url, number: String
}

func changeTheme(themeVal: String) {
  if #available(iOS 13.0, *) {
      //UserDefaults.standard.set(themeVal, forKey: "AppTheme")
      //UserDefaults.standard.synchronize()
     switch themeVal {
     case "dark":
         appDel.window?.overrideUserInterfaceStyle = .dark
         break
     case "light":
         appDel.window?.overrideUserInterfaceStyle = .light
         break
     default:
         appDel.window?.overrideUserInterfaceStyle = .light
     }
  }
}
