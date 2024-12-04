//
//  StoryDetails.swift
//  English Bible
//
//  Created by Abhik Das on 07/02/24.
//

import UIKit

class StoryDetails: BaseViewController {
    @IBOutlet var floatingReadVolumeVW:FloatingReadVolumeVW!
    
    @IBOutlet weak var tableContent: UITableView!
    @IBOutlet var lblStory:UILabel!
    @IBOutlet var lblChapter:UILabel!
    private var selectedStory:ModelStory!
    var selectedStoryFromList:ModelStoryList!
    private var selectedChapterNo:Int = 0
    @IBOutlet var vwHeader:UIView!
    private var allChapters:[Chapter] = []
    private var allVerses:[Verse] = []
    var isSelectOldTestement = true
    private var preferredFontSize:Float = 1
    
    @IBOutlet weak var vwGradient: DesignableGradientView!
    @IBOutlet weak var btnChangeChapter : UIButton!
    @IBOutlet weak var imgDropDown: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigation.lblHeader.text = selectedStoryFromList.shortName
        customNavigation.headerType = .back
        readVolumTabbarUISetup()
        setChapterChageSetup()
        selectedChapterNo = 0
        
        if let storyDetail = fetchStoryDetailsByCode(storyCode: selectedStoryFromList.code){
           self.selectedStory = storyDetail
           DispatchQueue.main.async {
               self.lblStory.text = self.selectedStory.longName
               self.lblChapter.text = "अध्याय \(self.selectedChapterNo + 1)"
               self.tableContent.reloadData()
           }
       }else{
           self.fetchStory {
               DispatchQueue.main.async {
                   self.lblStory.text = self.selectedStory.longName
                   self.lblChapter.text = "अध्याय \(self.selectedChapterNo + 1)"
                   self.tableContent.reloadData()
                   self.setupAudioList(storyNo: "अध्याय \(self.selectedChapterNo + 1)", storylongName: self.selectedStory.longName ?? "", audioUrl: self.selectedStory.chapters?[self.selectedChapterNo].audio ?? "", storyshortName: self.selectedStory.shortName ?? "", propertyTitle: self.selectedStory.shortName ?? ""  + "- अध्याय" + "\(self.selectedChapterNo)")
               }
           }
       }
        if isSelectOldTestement{
            floatingReadVolumeVW.isHidden = true
        }
        if let font = UserDefaults.standard.value(forKey: "preferredFont") as? Float{
            preferredFontSize = font
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
        self.lblChapter.textColor = isDarkModeON ? .white : .black
        imgDropDown.tintColor = isDarkModeON ? .white : .black
    }
    
    private func setChapterChageSetup(){
        btnChangeChapter.layer.cornerRadius = 10
        btnChangeChapter.clipsToBounds = true
        btnChangeChapter.layer.borderColor = UIColor.clear.cgColor
        btnChangeChapter.layer.borderWidth = 0.5
        vwGradient.layer.cornerRadius = 10
        vwGradient.clipsToBounds = true
        vwGradient.layer.borderWidth = 0.5
        vwGradient.layer.borderColor = UIColor.clear.cgColor
    }
    
    func readVolumTabbarUISetup(){
        ///// Call Custom Tabbar
        floatingReadVolumeVW.setup()
        floatingReadVolumeVW.myFloatingReadVolumeVWDelegate = self
    }
    @IBAction func changeChapter(_ sender: Any) {
        let arrchap = self.selectedStory.chapters?.map {
            "अध्याय " + "\($0.number ?? 0)"
        }
        guard let arrTemp = arrchap , arrTemp.count > 0 else {
            return
        }
        MyBasics.showListDropDown(Items: arrTemp , ParentViewC: self)
    }
    func setupAudioList(storyNo:String,storylongName:String,audioUrl:String,storyshortName:String,propertyTitle:String){
        selectedAudioProperty = SelectedAudioObject.init(selectedAudioStory: storyNo, selectedChapter: storylongName, selectedAudioUrl: audioUrl, propertyAlbumTitle: storyshortName, propertyTitle: propertyTitle, isSelectRepeat: false, isSelectShuffle: false)
        
    }
}

extension StoryDetails:CustomListDelegate{
    func GetSelectedPickerItemIndex(Index: Int) {
        selectedChapterNo = Index
        self.lblChapter.text = "अध्याय \(self.selectedChapterNo + 1)"
        self.tableContent.reloadData()
    }
}
//MARK: TABLE VIEW CALL

extension StoryDetails:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.selectedStory{
            vwHeader.isHidden = false
            return self.selectedStory.chapters?[selectedChapterNo].subtitles?.count ?? 0
        } else {
            vwHeader.isHidden = true
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedStory.chapters?[selectedChapterNo].subtitles?[section].verses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
        
        let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
        cell.lblContent.textColor = isDarkModeON ? UIColor.white : .darkGray
        let subtitleObject = self.selectedStory.chapters?[selectedChapterNo].subtitles?[indexPath.section]
        var subStr = "\(subtitleObject?.verses?[indexPath.row].number ?? "")" +  " \(String(describing: subtitleObject?.verses?[indexPath.row].content ?? ""))"
        if(subStr.first == "0"){
            subStr = replace(myString: subStr, 0, " ")
        }
        let attributedStrig = NSMutableAttributedString(string: subStr)
        let range = (subStr as NSString).range(of: "\(subtitleObject?.verses?[indexPath.row].number ?? "")")
        attributedStrig.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "AppBGColorDark")!, range: range)
        
        cell.lblContent.attributedText = attributedStrig
        cell.selectionStyle = .none
        cell.lblContent.fontSize = 8
        cell.viewWithTag(10)?.makeShadow()
        cell.contentView.backgroundColor = isDarkModeON ? .black : .white
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let subtitles = self.selectedStory.chapters?[selectedChapterNo].subtitles?[section].title
        
        let reference = self.selectedStory.chapters?[selectedChapterNo].subtitles?[section].reference ?? ""
        return subtitles?.count == 0 ? 0.1 : (reference.count == 0 ? 50 : 90)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        let subtitles = self.selectedStory.chapters?[selectedChapterNo].subtitles?[section].title ?? ""
        cell.lblTitle.text = subtitles
        let reference = self.selectedStory.chapters?[selectedChapterNo].subtitles?[section].reference
        cell.lblDesc.text = reference
        cell.gapLayout.constant = reference?.count ?? 0 > 0 ? 10 : 0
        let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
        vwHeader.backgroundColor = isDarkModeON ? .black : .white
        cell.contentView.backgroundColor = isDarkModeON ? .black : .white
        tableContent.backgroundColor = isDarkModeON ? .black : .white
        cell.lblDesc.textColor = isDarkModeON ? UIColor.white : .darkGray
        return subtitles.count == 0 ? nil : cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

//MARK: SCROLL VIEW CALL
extension StoryDetails:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /* This is the offset at the bottom of the scroll view. */
        let totalScroll = scrollView.contentSize.height - scrollView.bounds.size.height
        /* This is the current offset. */
        let offset = scrollView.contentOffset.y
        /* This is the percentage of the current offset / bottom offset. */
        let percentage = offset / totalScroll
        
        //debugPrint(percentage)
        
        floatingReadVolumeVW.changeReadBTNAppearence(alpha: percentage, animated: true)
        
    }
}

//MARK: FLOATING VIEW CALL
extension StoryDetails : FloatingReadVolumeVWDelegate{
    func GetSelectedFloatingReadVolumeVWIndex(Index: Int) {
        ////
        let index = Index
        switch(index) {
        case 0  :
            tableContent.setContentOffset(.zero, animated: true)
            break
        case 1 :
            
            ///option 1 audio by url
            
            ///get audio rl on selected chapter
            if let audioUrl = selectedStory.chapters?[selectedChapterNo].audio{
                floatingReadVolumeVW.btn_volume?.setImage(UIImage(named: "volume_off"), for: .normal)
                
                let avAudioObj =  AudioRepositoryClass()
                avAudioObj.callAudioByOption(option: .avAudio(urlString: audioUrl))
                
                avAudioObj.myAudioDelegate = self
                AudioVW.sharedInstance.stopSession()
            }else{
               /// Speach to text
                self.view.makeToast(NO_AUDIO)
            }
            break
        default:
            break
            
        }
    }
    
}
//MARK: AUDIO SPEECH CALL
extension StoryDetails : AudioRepositoryClassDelegate{
    func helper_unableToPlay() {
        DispatchQueue.main.async {
            showAlertMessage(title: App_Title, message: SOME_ERROR, vc: self)
            self.floatingReadVolumeVW.btn_volume?.setImage(UIImage(named: "volume_on"), for: .normal)
        }
    }
    
    func helper_startPlay() {
        DispatchQueue.main.async {
            self.floatingReadVolumeVW.btn_volume?.setImage(UIImage(named: "volume_off"), for: .normal)
        }
    }
    func helper_stopPlay() {
        floatingReadVolumeVW.btn_volume?.setImage(UIImage(named: "volume_on"), for: .normal)
    }
}

extension StoryDetails{
    func fetchStory(comHandler:@escaping(()->Void)){
        fetchChaptersLocal {
            comHandler()
        }
    }
    func fetchChaptersLocal(comHandler:@escaping(()->Void)) {
        self.callAllContentData {success in
            comHandler()
        }
    }
    func callAllContentData(handler:@escaping((Bool)->Void)){
        guard let reachInternet = Reachability(hostName: "https://www.google.co.in/") , reachInternet.isReachable == true else{
            self.view.makeToast(NETWORK_NOT_REACHABLE)
            return
        }
        guard let baseUrl = API.story_list.getURL()?.absoluteString else{return}
        let url_str = ( baseUrl + appLanguageCode + "/" + "\(selectedStoryFromList.code)")
        let operation = WebServiceOperation.init(url_str, nil, .WEB_SERVICE_GET, nil)
        operation.completionBlock = {
            DispatchQueue.main.async {
                guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                    showAlertMessage(title: App_Title, message: NO_DATA, vc: self)
                    
                    return
                }
                do{
                    
                    if let status = dictResponse["status"] as? Int , status == 200{
                        if let dictData = dictResponse["data"]  as? [String:Any], dictData.count > 0, let storyDetailData = dictData.data{
                            self.selectedStory = try JSONDecoder().decode(ModelStory.self, from: dictData.data!)
                            self.insertAllStoryDetail(allStoryData: storyDetailData)
                            handler(true)
                        }else{
                            showAlertMessage(title: App_Title, message: NO_DATA, vc: self)
                        }
                    }else{
                        showAlertMessage(title: App_Title, message: NO_DATA, vc: self)
                    }
                }catch {
                    showAlertMessage(title: App_Title, message: SOME_ERROR, vc: self)
                }
            }
        }
        appDel.operationQueue.addOperation(operation)
    }
}
struct SectionTable{
    var header : String///chapter_subtitle
    var verses:[Verse]?//[Verse]?
}
enum selectTab:Int{
    case story = 0
    case chapter
    case verse
    case language
}
