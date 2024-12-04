//
//  AudioStoryList.swift
//  English Bible
//
//  Created by Abhik Das on 19/07/22.
//

import UIKit

class AudioStoryList: BaseViewController {
    private var selectedChapterAudioList:ModelAudio!
    var selectedStoryFromList:ModelStoryList!
    @IBOutlet weak var tableContent: UITableView!
    @IBOutlet var vwAudio: UIView!
    
    var isSelectRepeat = false
    var isLocalSelectShuffle = false
    
    //let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        //call LOCAL DB OR API IN CONDITION
        fetchChaptersLocal()
        // Do any additional setup after loading the view.
        customNavigation.lblHeader.text = selectedStoryFromList.shortName
        customNavigation.headerType = .back
        
        if let _ = selectedAudioProperty{
            isSelectRepeat = selectedAudioProperty?.isSelectRepeat ?? false
            isLocalSelectShuffle = selectedAudioProperty?.isSelectShuffle ?? false
        }
        
        selectedAudioIndex = NSNotFound
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        /*
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableContent.addSubview(refreshControl) // not required when using UITableViewController
        */
    }
    @objc func refresh(_ sender: AnyObject) {
        debugPrint(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        self.callAllContentData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectedAudioIndex = UserDefaults.standard.integer(forKey: APP_SELECTED_AUDIO_INDEX)
        print("==================================")
        print(selectedAudioIndex)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPlayer()
    }
    
    func addPlayer(){
        if((vwAudio.viewWithTag(1500)) != nil){
            (vwAudio.viewWithTag(1500))?.removeFromSuperview()
        }
        let vw = AudioVW.sharedInstance
        vw.frame = vwAudio.bounds
        if let _ = selectedAudioProperty{
            vw.refreshAudioView()
        }
        vw.tag = 1500
        vw.myAudioVWDelegate = self
        vwAudio.addSubview(vw)
        audioRefresh()
    }
    func audioRefresh(){
        if let _ = selectedAudioProperty{
            AudioVW.sharedInstance.refreshAudioView()
        }
    }
    func fetchChaptersLocal() {
        if let storyAudioList = fetchAudioListByCode(storyCode: selectedStoryFromList.code){
            selectedChapterAudioList = storyAudioList
            tableContent.reloadData()
        }else{
            callAllContentData()
        }
    }
}
//Mark: - TableView Extention
extension AudioStoryList: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedChapterAudioList?.chapters?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CommonCellTableViewCell = self.tableContent.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell") as! CommonCellTableViewCell
        
        cell.lblInfo.text = "\(selectedChapterAudioList?.shortName  ?? "") अध्याय \(selectedChapterAudioList?.chapters?[indexPath.row].number ?? 0)"
        cell.btnInstance1.setImage(UIImage(named: "play"), for: .normal)
        if(indexPath.row == selectedAudioIndex){
            if let number = selectedChapterAudioList?.chapters?[selectedAudioIndex].number, "\(number)" == selectedAudioProperty?.selectedAudioStory{
                cell.btnInstance1.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
        cell.vwContainer1.backgroundColor = .clear
        //cell.vwContainer1.makeShadow()
        cell.selectionStyle = .none
        cell.vwContainer1.layer.cornerRadius = 10
        cell.btnInstance1.layer.cornerRadius = 10
        cell.btn1Protocol = self
        let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
        cell.contentView.backgroundColor = isDarkModeON ? .black : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
//MARK: TABLE CELL DELEGATE CALL
extension AudioStoryList :ButtonInstance1Delegate{
    func selectedButton1Instance(cell: UITableViewCell) {
        if let indexPath = tableContent.indexPath(for: cell) {
            selectedAudioIndex = indexPath.row
            UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
            playAudioByIndex("next")
        }
    }
    
    func playAudioByIndex(_ moved:String){
        AvAudioHelperClass.sharedInstance.stopAudioSession()
        guard let reachInternet = Reachability(hostName: "https://www.google.co.in/") , reachInternet.isReachable == true else{
            self.view.makeToast(NETWORK_NOT_REACHABLE)
            return
        }
        
        
        if(selectedAudioIndex == NSNotFound){
            self.view.makeToast(SELECT_AUDIO_TO_PLAY)
            return
        }
        if((selectedChapterAudioList?.chapters?.count ?? 0) < selectedAudioIndex){
            self.view.makeToast(SOME_ERROR)
            selectedAudioIndex -= 1
            UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
            return
        }
        
        if let obj  = selectedChapterAudioList?.chapters?[selectedAudioIndex], let audioUrl = obj.audio{
            AudioVW.sharedInstance.myAudioVWDelegate = self
             
            if (moved == "next" || moved == "previous"){
                AudioVW.sharedInstance.isPlaying = false
            }
          
            selectedAudioProperty = SelectedAudioObject.init(selectedAudioStory: "\(obj.number ?? 0)", selectedChapter: selectedStoryFromList.longName, selectedAudioUrl: audioUrl, propertyAlbumTitle: selectedStoryFromList.shortName, propertyTitle: "\(selectedChapterAudioList?.shortName  ?? "") अध्याय \(obj.number ?? 0)", isSelectRepeat: false, isSelectShuffle: false)
            
            AudioVW.sharedInstance.startPlaying()
            tableContent.reloadData()
        }else{
            self.view.makeToast(NO_AUDIO)
        }
    }
}

extension AudioStoryList : CustomMAudioVWDelegate{
    func repeate() {
        isSelectRepeat = !isSelectRepeat
        if(isSelectRepeat){
            AudioVW.sharedInstance.btnRpeat.setImage(UIImage(named: "RepeatON"), for: .normal)
            self.view.makeToast(REPEATE_SELECTED)
        }else{
            AudioVW.sharedInstance.btnRpeat.setImage(UIImage(named: "repeat"), for: .normal)
            self.view.makeToast(REPEATE_DESELECTED)
        }
    }
    func audioFinish() {
     guard selectedAudioIndex != NSNotFound else{
            return
        }
        
        if(selectedAudioIndex <= ((selectedChapterAudioList.chapters?.count ?? 0) - 1)){
            if(isSelectRepeat){
                /////playlist has been completed and user has selected repeat. Other wise song will not be played while repeat has not been selected
                selectedAudioIndex = 0
             }else{
                if selectedAudioIndex == ((selectedChapterAudioList.chapters?.count ?? 0) - 1){
                    //selectedAudioIndex = 0
                    UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
                    return
                }else{
                    selectedAudioIndex = selectedAudioIndex + 1
                 }
                /*
                selectedAudioIndex = NSNotFound
                tableContent.reloadData()
                AudioVW.sharedInstance.playButton?.setImage(UIImage(named: "play"), for: .normal)
                return*/
            }
            
        }else{
            if(isLocalSelectShuffle){
                selectedAudioIndex = generateRandomIndex()
            }else{
                selectedAudioIndex += 1
            }
        }
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        playAudioByIndex("next")
        debugPrint(isLocalSelectShuffle)
        tableContent.reloadData()
    }
    func shuffle() {
        
        isLocalSelectShuffle = !isLocalSelectShuffle
        if(isLocalSelectShuffle){
            self.view.makeToast(SHUFFLE_SELECTED)
        }else{
            self.view.makeToast(SHUFFLE_DESELECTED)
        }
       
    }

    func startFromaudioVW() {
        
        if selectedAudioIndex == NSNotFound {
            selectedAudioIndex = 0
        }
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        playAudioByIndex("")
        tableContent.reloadData()
    }
    
    func startPlay() {
        DispatchQueue.main.async {
            AudioVW.sharedInstance.playButton?.setImage(UIImage(named: "pause"), for: .normal)
        }
        if(selectedAudioIndex == NSNotFound && selectedAudioProperty != nil){
            if let index = (selectedChapterAudioList.chapters)?.firstIndex(where: {"\($0.number ?? 0)" == selectedAudioProperty.selectedChapter}) {
                selectedAudioIndex = index
            }
        }
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        DispatchQueue.main.async {
            self.tableContent.reloadData()
        }
        
    }
    
    func stopPlay() {
        //selectedAudioIndex = NSNotFound
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        tableContent.reloadData()
        AudioVW.sharedInstance.playButton?.setImage(UIImage(named: "play"), for: .normal)
    }
    
    func unableToPlay() {
        self.view.makeToast(AUDIO_ERROR)
        //selectedAudioIndex = NSNotFound
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        tableContent.reloadData()
        AudioVW.sharedInstance.playButton?.setImage(UIImage(named: "play"), for: .normal)
    }
    
    func nextPlay() {
        guard selectedAudioIndex != NSNotFound else{
            return
        }
        if(selectedAudioIndex >= ((selectedChapterAudioList.chapters?.count ?? 0) - 1)){
            selectedAudioIndex = 0
        }else{
            selectedAudioIndex += 1
        }
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        playAudioByIndex("next")
        
    }
    
    func previousPlay() {
        guard selectedAudioIndex != NSNotFound else{
            return
        }
        if(selectedAudioIndex == 0){
            selectedAudioIndex = (selectedChapterAudioList.chapters?.count ?? 0) - 1
        }else{
            selectedAudioIndex -= 1
        }
        
        UserDefaults.standard.set(selectedAudioIndex, forKey: APP_SELECTED_AUDIO_INDEX)
        playAudioByIndex("previous")
        tableContent.reloadData()
    }
    
    func generateRandomIndex() -> Int{
        var randomCount = 0
        if let count = selectedChapterAudioList.chapters?.count{
            randomCount = count
        }
        let randomInt = Int.random(in: 0..<randomCount)
        return randomInt
    }
    
}

extension AudioStoryList{
    func callAllContentData(){
        guard let reachInternet = Reachability(hostName: "https://www.google.co.in/") , reachInternet.isReachable == true else{
            self.view.makeToast(NETWORK_NOT_REACHABLE)
            return
        }
        guard let baseUrl = API.audio_list.getURL()?.absoluteString else{return}
        let url_str = ( baseUrl + appLanguageCode + "/" + "\(selectedStoryFromList.code)/audio")
        let operation = WebServiceOperation.init(url_str, nil, .WEB_SERVICE_GET, nil)
        operation.completionBlock = {
            DispatchQueue.main.async {
                guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                    showAlertMessage(title: App_Title, message: NO_DATA, vc: self)
                    return
                }
                do{
                    if let status = dictResponse["status"] as? Int , status == 200{
                        if let dictData = dictResponse["data"]  as? [String:Any], dictData.count > 0, let audioDetailData = dictData.data{
                            self.selectedChapterAudioList = try JSONDecoder().decode(ModelAudio.self, from: dictData.data!)
                            self.tableContent.reloadData()
                            self.insertAudioData(allStoryAudioData: audioDetailData)
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
