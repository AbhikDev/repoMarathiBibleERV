//
//  AppSettingsVC.swift
//  Good News Bible app
//
//  Created by Abhik Das on 19/04/22.
//

import UIKit

class AppSettingsVC: BaseViewController {
    @IBOutlet private var myScrollView:UIScrollView!
    @IBOutlet private var vwContainer: UIView!
    @IBOutlet private var lblSample: BibleHomeLable!
    
    @IBOutlet private var btnAudio: UIButton!
    
    @IBOutlet private var menuTable: UITableView!
    private var arrSettingsOptionSelected = [false]//,false]
    
    private var preferredFontSize:Float = 1
    private var preferredVolume:Float = 0.5
    private var arrSettingsOption = ["App Font"]//, "App Volume"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigation.lblHeader.text = "App Settings"
        customNavigation.headerType = .back
        // Do any additional setup after loading the view.
        self.myScrollView.setContentOffset(CGPoint(x: 0, y: self.myScrollView.contentOffset.y), animated: false)
        myScrollView.contentSize = CGSize(width: self.myScrollView.frame.size.width, height: self.vwContainer.frame.size.height)
        
        if let font = UserDefaults.standard.value(forKey: "preferredFont") as? Float{
            preferredFontSize = font
        }
        updateVWFontHelper()
        if let volume = UserDefaults.standard.value(forKey: "preferredVolume") as? Float {
            let doubleStr = String(format: "%.2f", volume)
            preferredVolume = Float(doubleStr)!
        }
        
        lblSample.text = "Presently this App \(App_Title ?? "ପବିତ୍ର ବାଇବଲ") is the complete Bible version in Hindi language. The content is available both for the Old Testament and the New Testament. Audio is also available. This app is simple to use and does not require any personal information of the user."
        let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
        lblSample.textColor = isDarkModeON ? .white : .black
    }
    @IBAction func speachToText(){
        AudioSpeachHelperClass.sharedInstance.hereSpeach(speach: lblSample.text!, languageCode: "en-US")
        AudioSpeachHelperClass.sharedInstance.myspeachDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fontsizeChange(size: Int(preferredFontSize))
    }
    func fontsizeChange(size:Int) {
       self.lblSample.fontSize = size
    }
}
//Mark: - TableView Extention
extension AppSettingsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrSettingsOptionSelected.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettingsOptionSelected[section] == true ? 1 : 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: CommonCellTableViewCell = self.menuTable.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell1") as! CommonCellTableViewCell
        cell.lblInfo.text = arrSettingsOption[section]
        cell.vwContainer1.makeShadow()
        cell.selectionStyle = .none
        
        cell.imgContent.image = arrSettingsOptionSelected[section] == true ? UIImage(named: "dropUP") : UIImage(named: "dropdown")
       
        cell.btnInstance1.tag = section
        cell.btnInstance1.setTitle("", for: .normal)
        cell.btnInstance1.addTarget(self, action: #selector(opensettings), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommonCellTableViewCell = self.menuTable.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell2") as! CommonCellTableViewCell
        
        cell.lblInfo.text = "\(preferredFontSize)"
        
        cell.mySlider.tag = indexPath.section
        cell.mySlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
             
        let index  = indexPath.section
        
        let timing = 0.1
        switch(index) {
        case 0 :
            cell.lblInfo.text = "\(Int(preferredFontSize))"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timing) {
                cell.mySlider.value = Float(Int(self.preferredFontSize))
            }
            cell.mySlider.minimumValue = 1
            cell.mySlider.maximumValue = 15
            break
        case 1:
            cell.lblInfo.text = "\(preferredVolume)"
            cell.mySlider.minimumValue = 0.5
            cell.mySlider.maximumValue = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timing) {
                cell.mySlider.value = Float(self.preferredVolume)
            }
            break
        default:
            break
        }
        return cell
        
    }
    @objc func opensettings(_ sender:UIButton){
        let tempArr = arrSettingsOptionSelected
        for (index,_)  in arrSettingsOptionSelected.enumerated(){
            arrSettingsOptionSelected[index] = false
        }
        arrSettingsOptionSelected[sender.tag] = !tempArr[sender.tag]
       
        menuTable.reloadData()
    }
    @objc func sliderValueChanged(_ sender:UISlider){
        let currentValue = Float(sender.value)
        
        if(sender.tag == 0){
            preferredFontSize = (currentValue)
            //curretUser?.font = Double(Int(currentValue))
            //CoreDataHelperClass.sharedInstance.save()
            UserDefaults.standard.setValue(preferredFontSize, forKey: "preferredFont")
            UserDefaults.standard.synchronize()
            updateVWFontHelper()
        }else{
            let myDouble = currentValue
            let doubleStr = String(format: "%.2f", myDouble)
            preferredVolume = Float(doubleStr)!
            UserDefaults.standard.setValue(preferredVolume, forKey: "preferredVolume")
            UserDefaults.standard.synchronize()
            //curretUser?.preferredVolume = Double(preferredVolume)
            //CoreDataHelperClass.sharedInstance.save()
            ////// manipulate text to speech volume
            if(AudioSpeachHelperClass.sharedInstance.speechSynthesizer.isSpeaking){
                AudioSpeachHelperClass.sharedInstance.speechSynthesizer.stopSpeaking(at: .immediate)
                AudioSpeachHelperClass.sharedInstance.speechSynthesizer.speak( AudioSpeachHelperClass.sharedInstance.buildUtterance(for: preferredVolume, with: lblSample.text!))
            }
        }
        menuTable.reloadData()
        
    }
    
}
extension AppSettingsVC{
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    func updateVWFontHelper(){
        lblSample.font = UIFont(name: lblSample.font.fontName, size: CGFloat(preferredFontSize + fixedFont))
    }
}

////Speach Delegate work
extension AppSettingsVC : CustomSpeachDelegate{
    func startSpeach() {
        btnAudio.setImage(UIImage(named: "volume_off"), for: .normal)
    }
    
    func stopSpeach() {
        btnAudio.setImage(UIImage(named: "volume_on"), for: .normal)
    }
}
struct CurrentUser{
    var preferredFont : Double
    var preferredVolume: Double
}
