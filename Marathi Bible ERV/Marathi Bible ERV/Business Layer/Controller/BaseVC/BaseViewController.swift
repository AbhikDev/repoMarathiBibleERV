//
//  BaseViewController.swift
//  Good News Bible app
//
//  Created by Abhik Das on 27/12/21.
//

import UIKit
import SideMenu
import Toast_Swift
class BaseViewController: UIViewController {
    
    @IBOutlet var customNavigation:CustomNavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarUIView?.backgroundColor =  UIColor(named: "AppBGColorDark")

        ////setup default volume
        //curretUser?.language_id = 1
        dboperationForDefaultLanguage()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    func checkInitials(){
        if let _ = UserDefaults.standard.value(forKey: "preferredFont") as? Float{
        }else{
            let preferredFontSize = 1
            UserDefaults.standard.setValue(preferredFontSize, forKey: "preferredFont")
            UserDefaults.standard.synchronize()

        }
        if let _ = UserDefaults.standard.value(forKey: "preferredVolume") as? Float {}else{
            let myDouble = 0.5
            let doubleStr = String(format: "%.2f", myDouble)
            let preferredVolume = Float(doubleStr)!
            UserDefaults.standard.setValue(preferredVolume, forKey: "preferredVolume")
            UserDefaults.standard.synchronize()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func dboperationForDefaultLanguage(){
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //changeTheme(themeVal: "light")
    }
    func showLanguagePicker(){
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setPreviouslySavedTheme()
    }
    func setPreviouslySavedTheme(){
        let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
        if isDarkModeON {
            changeTheme(themeVal: "dark")
        }else{
            changeTheme(themeVal: "light")
        }
    }
}
extension BaseViewController {
    func insertAllStoryList(allStoryData dataStoryDetails:Data){
        do{
            let storyModel = try JSONDecoder().decode([ModelStoryList].self, from: dataStoryDetails)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(storyModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: APP_KEY_ALL_STORY)
            }
        }catch{
            
        }
    }
    func fetchAllStories() -> [ModelStoryList]?{
        if let savedPerson = UserDefaults.standard.object(forKey: APP_KEY_ALL_STORY) as? Data {
            let decoder = JSONDecoder()
            if let storyModel = try? decoder.decode([ModelStoryList].self, from: savedPerson) {
                return storyModel
            }
            
        }
        return nil
    }
    func insertAllStoryDetail(allStoryData dataStoryDetails:Data){
        do{
            let storyModel = try JSONDecoder().decode(ModelStory.self, from: dataStoryDetails)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(storyModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: APP_KEY_STORY_DETAILS)
            }
        }catch{
            
        }
    }
    func fetchStoryDetailsByCode(storyCode:String) -> ModelStory?{
        if let savedPerson = UserDefaults.standard.object(forKey: APP_KEY_STORY_DETAILS) as? Data {
            let decoder = JSONDecoder()
            if let storyModel = try? decoder.decode(ModelStory.self, from: savedPerson) {
                return storyModel.code == storyCode ? storyModel : nil
            }
        }
        return nil
    }
    func insertAudioData(allStoryAudioData dataStoryDetails:Data){
        do{
            let storyModel = try JSONDecoder().decode(ModelAudio.self, from: dataStoryDetails)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(storyModel) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: APP_KEY_AUDIO_LIST)
            }
        }catch{
            
        }
    }
    func fetchAudioListByCode(storyCode:String) -> ModelAudio?{
        if let savedPerson = UserDefaults.standard.object(forKey: APP_KEY_AUDIO_LIST) as? Data {
            let decoder = JSONDecoder()
            if let storyAudioModel = try? decoder.decode(ModelAudio.self, from: savedPerson) {
                //return storyAudioModel
                return storyAudioModel.code == storyCode ? storyAudioModel : nil
            }
        }
        return nil
    }
}

