//
//  AudioVW.swift
//  English Bible
//
//  Created by Abhik Das on 20/07/22.
//

import UIKit

import AVFoundation
import MediaPlayer
import Alamofire

@objc protocol CustomMAudioVWDelegate {
    func startPlay()
    func stopPlay()
    func unableToPlay()
    func nextPlay()
    func previousPlay()
    func shuffle()
    func repeate()
    func startFromaudioVW()
    func audioFinish()
}
class AudioVW: UIView {
    static let sharedInstance = AudioVW()
    @IBOutlet fileprivate var view:UIView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var btnRpeat: UIButton!
    var myAudioVWDelegate:CustomMAudioVWDelegate?
    private var isScrubbing: Bool = false
    //private let controller = AudioController.shared
    private var lastLoadFailed: Bool = false
    
    /////data set
    //var audioUrl = ""
    
    var avPlayer: AVAudioPlayer!
    //var avPlayer: AVAudioPlayer = AVAudioPlayer()
    var isPlaying = false
    private var preferredVolume:Float = 1.0
    //let commandCenter = MPRemoteCommandCenter.shared()
    @IBOutlet weak var slider: UISlider!{
        didSet {
            slider.addTarget(self, action: #selector(didBeginDraggingSlider), for: .touchDown)
            slider.addTarget(self, action: #selector(didEndDraggingSlider), for: .valueChanged)
            slider.isContinuous = false
        }
    }
    lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(updatePlaybackStatus))
    
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
        if let view = Bundle.main.loadNibNamed("AudioVW", owner: self, options: nil)?.first as? UIView {
            self.view = view
            self.view.frame = self.bounds
            
            self.addSubview(self.view)
        }
    }
    func refreshAudioView(){
        
        titleLabel.text = selectedAudioProperty?.propertyTitle
    }
    func startPlaying(){
        /*if let volume = curretUser?.preferredVolume{
         let doubleStr = String(format: "%.2f", volume)
         preferredVolume = Float(doubleStr)!
         }*/
        if let volume = UserDefaults.standard.value(forKey: "preferredVolume") as? Float{
            preferredVolume = volume
        }
        guard let audioUrl = URL(string: (selectedAudioProperty?.selectedAudioUrl ?? "")) else{
            DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
                self?.myAudioVWDelegate?.unableToPlay()
            }
            
            return
        }
        /*if let volume = curretUser?.preferredVolume{
         let doubleStr = String(format: "%.2f", volume)
         preferredVolume = Float(doubleStr)!
         }*/
        //do{             ////Play or stop audio
            
            if (!isPlaying){
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        //try FileManager.default.moveItem(at: location, to: destinationUrl)
                        
                        self.avPlayer = try AVAudioPlayer(contentsOf: location)
                        self.playAudio()
                    } catch let error as NSError {
                        self.isPlaying = false
                        DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
                            self?.myAudioVWDelegate?.unableToPlay()
                        }
                    }
                }).resume()
                
                /*let data = try Data(contentsOf: url)
                 avPlayer = try AVAudioPlayer(data: data)
                 avPlayer.prepareToPlay()
                 avPlayer.volume = preferredVolume
                 avPlayer.delegate = self
                 titleLabel.text = selectedAudioProperty?.propertyTitle
                 
                 //To support media playing in background
                 startSession()
                 
                 ///slider progress
                 startUpdatingPlaybackStatus()
                 ///Notification bar work
                 
                 
                 setupMPRemoteCommandCenter()
                 /// audio player start delegate called
                 myAudioVWDelegate?.startPlay()*/
                
            }else{
                //To support media playing in background
                stopSession()
                
                stopUpdatingPlaybackStatus()
                myAudioVWDelegate?.stopPlay()
            }
        /*}catch{
            isPlaying = false
            DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
                self?.myAudioVWDelegate?.unableToPlay()
            }
        }*/
    }
    func playAudio(){
        
        avPlayer.prepareToPlay()
        avPlayer.volume = preferredVolume
        avPlayer.delegate = self
        DispatchQueue.main.async {
            self.titleLabel.text = selectedAudioProperty?.propertyTitle
        }
        
        //To support media playing in background
        startSession()
      
        ///slider progress
        startUpdatingPlaybackStatus()
        ///Notification bar work
        setupMPRemoteCommandCenter()
        /// audio player start delegate called
        myAudioVWDelegate?.startPlay()
    }
}
//MARK : Slider and progress work
extension AudioVW{
    func startUpdatingPlaybackStatus() {
        displayLink.add(to: .main, forMode: .common)
    }
    
    func stopUpdatingPlaybackStatus() {
        displayLink.remove(from: .main, forMode: .common)
        //displayLink.invalidate()
    }
    
    @objc
    func updatePlaybackStatus() {
        let playbackProgress = Float(avPlayer.currentTime / avPlayer.duration)
        
        slider.setValue(playbackProgress, animated: true)
        updateTime()
    }
    
    // 2
    @objc
    func didBeginDraggingSlider() {
        displayLink.isPaused = true
    }
    
    @objc
    func didEndDraggingSlider() {
        let newPosition = avPlayer.duration * Double(slider.value)
        avPlayer.currentTime = newPosition
        
        displayLink.isPaused = false
        
    }
    func updateTime() {
        let currentTime = Int(avPlayer.currentTime)
        let duration = Int(avPlayer.duration)
        
        elapsedTimeLabel.text = Double(duration).secondsToString()
        remainingTimeLabel.text = Double(currentTime).secondsToString()
    }
}
extension AudioVW{
    ////Mark : NOTIFCATION AUDIO PLAYER SETUP
    func setupMPRemoteCommandCenter(){
        //Configuring Remote commands
        let commandCenter = MPRemoteCommandCenter.shared()
      
        commandCenter.togglePlayPauseCommand.addTarget(handler: {[weak self] event in
            self?.playPause()
            return .success
        })
        
        let skipBackwardCommand = commandCenter.skipBackwardCommand
        skipBackwardCommand.isEnabled = false
        let skipForwardCommand = commandCenter.skipForwardCommand
        skipForwardCommand.isEnabled = false
       
        commandCenter.playCommand.addTarget(handler: {[weak self] event in
            self?.playPause()
            return .success
        })
        commandCenter.pauseCommand.addTarget(handler: {[weak self] event in
            self?.playPause()
            return .success
        })
     
        //Configuring Now Playing Info Center
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = selectedAudioProperty?.propertyTitle
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = selectedAudioProperty?.propertyAlbumTitle
        nowPlayingInfo[MPMediaItemPropertyArtist] = "\(App_Title ?? "ପବିତ୍ର ବାଇବଲ")"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = avPlayer.duration
        nowPlayingInfo[MPMediaItemPropertyArtist] = MPMediaItemArtwork(boundsSize: UIImage(named: "AppLogo")!.size, requestHandler: { (size) -> UIImage in
            return UIImage(named: "AppLogo")!
        })
        
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = "\(avPlayer.currentTime)"
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    func skipBackward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        let interval = command.preferredIntervals[0]
        debugPrint(interval)
        return .success
    }

    func skipForward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        let interval = command.preferredIntervals[0]
        debugPrint(interval)
        return .success
    }
}
extension AudioVW:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        AudioVW.sharedInstance.playButton?.setImage(UIImage(named: "play"), for: .normal)
        myAudioVWDelegate?.audioFinish()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        myAudioVWDelegate?.stopPlay()
    }
}
extension AudioVW{
    @IBAction func togglePlay(_ sender: Any) {
        playPause()
    }
    
    func playPause(){
        if((selectedAudioProperty?.selectedAudioUrl ?? "").count == 0){
            myAudioVWDelegate?.startFromaudioVW()
        }else{
            if (isPlaying){
                if avPlayer != nil{
                    avPlayer.stop()
                }
                stopUpdatingPlaybackStatus()
                isPlaying = false
                myAudioVWDelegate?.stopPlay()
                
            }else{
                if avPlayer != nil{
                    if(!avPlayer.isPlaying){
                        avPlayer.stop()
                        avPlayer.play()
                    }else{
                        avPlayer.play()
                    }
                }
                startUpdatingPlaybackStatus()
                isPlaying = true
                myAudioVWDelegate?.startPlay()
            }
        }
    }
    @IBAction func previous(_ sender: Any) {
        previousPlay()
    }
    func previousPlay(){
        myAudioVWDelegate?.previousPlay()
    }
    
    @IBAction func next(_ sender: Any) {
        nextPlay()
    }
    func nextPlay(){
        myAudioVWDelegate?.nextPlay()
    }
    @IBAction func makeShuffle(_ sender: Any) {
        if((selectedAudioProperty?.selectedAudioUrl ?? "").count == 0){
            myAudioVWDelegate?.startFromaudioVW()
        }else{
            myAudioVWDelegate?.shuffle()
        }
    }
    @IBAction func makeRepeat(_ sender: Any) {
        if((selectedAudioProperty?.selectedAudioUrl ?? "").count == 0){
            myAudioVWDelegate?.startFromaudioVW()
        }else{
            myAudioVWDelegate?.repeate()
        }
    }
    func startSession(){
        do{
            isPlaying = true
            avPlayer.play()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            debugPrint("unable to start session")
        }
    }
    func stopSession(){
        do{
            isPlaying = false
            if avPlayer != nil{
                if(avPlayer.isPlaying){
                    avPlayer.stop()
                }
            }
           
            try AVAudioSession.sharedInstance().setActive(false)
        }catch{
            debugPrint("unable to stop session")
        }
        
    }
}
