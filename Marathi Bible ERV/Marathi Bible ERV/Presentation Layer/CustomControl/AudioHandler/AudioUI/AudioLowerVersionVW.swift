//
//  AudioLowerVersionVW.swift
//  English Bible
//
//  Created by Abhik Das on 04/08/22.
//

import Foundation
import UIKit

import AVFoundation
import AVKit
import MediaPlayer

class AudioLowerVersionVW: UIView {
    static let sharedInstance = AudioLowerVersionVW()
    @IBOutlet fileprivate var view:UIView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var myAudioVWDelegate:CustomMAudioVWDelegate?
    private var isScrubbing: Bool = false
    //private let controller = AudioController.shared
    private var lastLoadFailed: Bool = false
    
    /////data set
    //var audioUrl = ""
    
    var avPlayer: AVPlayer!// = AVPlayer()
    //var avPlayer: AVAudioPlayer!// = AVAudioPlayer()
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
        if let view = Bundle.main.loadNibNamed("AudioLowerVersionVW", owner: self, options: nil)?.first as? UIView {
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
        //(selectedAudioProperty?.selectedAudioUrl ?? "")
        guard let url = URL(string:(selectedAudioProperty?.selectedAudioUrl ?? "")) else{
            DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
                self?.myAudioVWDelegate?.unableToPlay()
            }
            
            return
        }
      
        do{
            ////Play or stop audio
            
            if (!isPlaying){
               playAudio(url)
                
                titleLabel.text = selectedAudioProperty?.propertyTitle
                
                //To support media playing in background
                startSession()
                
                ///slider progress
                startUpdatingPlaybackStatus()
                ///Notification bar work
                
                
                setupMPRemoteCommandCenter()
                /// audio player start delegate called
                myAudioVWDelegate?.startPlay()
                /*
                 avPlayer = AVPlayer(url: url)
                 
                 avPlayer?.volume = preferredVolume
                 
                 titleLabel.text = selectedAudioProperty?.propertyTitle
                 
                 //To support media playing in background
                 startSession()
                 
                 ///slider progress
                 startUpdatingPlaybackStatus()
                 ///Notification bar work
                 
                 
                 setupMPRemoteCommandCenter()
                 /// audio player start delegate called
                 myAudioVWDelegate?.startPlay()
                 */
            }else{
                //To support media playing in background
                stopSession()
                
                stopUpdatingPlaybackStatus()
                myAudioVWDelegate?.stopPlay()
            }
        }catch let _{
            //print("=======error")
            //print(e)
            isPlaying = false
            DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
                self?.myAudioVWDelegate?.unableToPlay()
            }
        }
    }
    func playAudio(_ audioUrl:URL){
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else {
              print("Invalid url")
              return
            }
            let playerItem = AVPlayerItem(url: url)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer.play()
       
    }
}
//MARK : Slider and progress work
extension AudioLowerVersionVW{
    func startUpdatingPlaybackStatus() {
        displayLink.add(to: .main, forMode: .common)
    }
    
    func stopUpdatingPlaybackStatus() {
        displayLink.remove(from: .main, forMode: .common)
        //displayLink.invalidate()
    }
    
    @objc
    func updatePlaybackStatus() {
        /*let playbackProgress = Float(avPlayer.currentTime / avPlayer.duration)
        
        slider.setValue(playbackProgress, animated: true)
        updateTime()
        */
        /*
        // 1 . Guard got compile error because `videoPlayer.currentTime()` not returning an optional. So no just remove that.
        let playbackProgress = CMTimeGetSeconds(avPlayer?.currentTime() ?? CMTime.zero)
        
        slider.setValue(Float(playbackProgress), animated: true)
        updateTime()
        */
    }
    
    // 2
    @objc
    func didBeginDraggingSlider() {
        displayLink.isPaused = true
    }
    
    @objc
    func didEndDraggingSlider() {
        /*let newPosition = avPlayer.duration * Double(slider.value)
        avPlayer.currentTime = newPosition
        
        displayLink.isPaused = false
        */
        
        let showingTime: CMTime = CMTimeMakeWithSeconds(Float64(slider.value), preferredTimescale: 1);
        avPlayer.seek(to: showingTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        
        displayLink.isPaused = false
        
    }
    func updateTime() {
        /*
        let currentTime = Int(avPlayer.currentTime)
        let duration = Int(avPlayer.duration)
        
        elapsedTimeLabel.text = Double(duration).secondsToString()
        remainingTimeLabel.text = Double(currentTime).secondsToString()
        */
         
        if let player = avPlayer {
            let currentTime = Int(player.currentTime().value)
            let duration = Int(player.currentTime().value) / Int(player.currentTime().timescale)
         
            elapsedTimeLabel.text = Double(duration).secondsToString()
            remainingTimeLabel.text = Double(currentTime).secondsToString()
        }
    }
}
extension AudioLowerVersionVW{
    ////Mark : NOTIFCATION AUDIO PLAYER SETUP
    func setupMPRemoteCommandCenter(){
        
        //Configuring Remote commands
        let commandCenter = MPRemoteCommandCenter.shared()
        
         
        commandCenter.togglePlayPauseCommand.addTarget(handler: {[weak self] event in
            
            self?.playPause()
            return .success
        })
        
        let skipTime: NSNumber = 5
        //commandCenter.skipForwardCommand.preferredIntervals = [skipTime]
        //commandCenter.skipBackwardCommand.preferredIntervals = [skipTime]
        let skipBackwardCommand = commandCenter.skipBackwardCommand
        skipBackwardCommand.isEnabled = true
        skipBackwardCommand.addTarget(handler: skipBackward)
        skipBackwardCommand.preferredIntervals = [skipTime]

        let skipForwardCommand = commandCenter.skipForwardCommand
        skipForwardCommand.isEnabled = true
        skipForwardCommand.addTarget(handler: skipForward)
        skipForwardCommand.preferredIntervals = [skipTime]
        
        
        commandCenter.nextTrackCommand.addTarget(handler: {[weak self] event in
            
            self?.nextPlay()
            return .success
        })
        commandCenter.previousTrackCommand.addTarget(handler: {[weak self] event in
            
            self?.previousPlay()
            return .success
        })
        
        //Configuring Now Playing Info Center
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = selectedAudioProperty?.propertyTitle
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = selectedAudioProperty?.propertyAlbumTitle
        nowPlayingInfo[MPMediaItemPropertyArtist] = "\(App_Title ?? "ପବିତ୍ର ବାଇବଲ")"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = avPlayer.currentItem?.asset.duration
        
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

        debugPrint(interval) //Output: 42

        return .success
    }

    func skipForward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }

        let interval = command.preferredIntervals[0]

        debugPrint(interval) //Output: 42

        return .success
    }
}

extension AudioLowerVersionVW{
    @IBAction func togglePlay(_ sender: Any) {
        playPause()
    }
    
    func playPause(){
        if((selectedAudioProperty?.selectedAudioUrl ?? "").count == 0){
            myAudioVWDelegate?.startFromaudioVW()
        }else{
            if (isPlaying){
                stopAVPlayer()
                stopUpdatingPlaybackStatus()
                isPlaying = false
                myAudioVWDelegate?.stopPlay()
                
            }else{
                avPlayer.play()
                startUpdatingPlaybackStatus()
                isPlaying = true
                myAudioVWDelegate?.startPlay()
            }
        }
    }
    func stopAVPlayer() {
        avPlayer.pause()
        /*
        if let play = avPlayer {
            print("stopped")
            play.pause()
            avPlayer = nil
            print("player deallocated")
        } else {
            print("player was already deallocated")
        }*/
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
        myAudioVWDelegate?.shuffle()
    }
    @IBAction func makeRepeat(_ sender: Any) {
        myAudioVWDelegate?.repeate()
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
            stopAVPlayer()
            try AVAudioSession.sharedInstance().setActive(false)
        }catch{
            debugPrint("unable to stop session")
        }
        
    }
}
extension AudioLowerVersionVW:AVAudioPlayerDelegate{
    
}
