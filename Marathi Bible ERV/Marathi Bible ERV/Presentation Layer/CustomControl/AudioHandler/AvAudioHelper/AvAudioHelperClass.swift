//
//  AvAudioHelperClass.swift
//  Good News Bible app
//
//  Created by Abhik Das on 09/01/22.
//

import UIKit
import AVFoundation
import MediaPlayer
@objc protocol CustomMyAvAudioHelperClassDelegate {
    func startPlay()
    func stopPlay()
    func unableToPlay()
}
class AvAudioHelperClass: NSObject {
    static let sharedInstance = AvAudioHelperClass()
    var myAvAudioDelegate:CustomMyAvAudioHelperClassDelegate?
    
    //var avPlayer: AVAudioPlayer = AVAudioPlayer()
    var avPlayer: AVAudioPlayer!// = AVAudioPlayer()
    var isPlaying = false
    private var preferredVolume:Float = 0.5
    func setupAudioByUrl(urlStr:String){
        guard let audioUrl = URL(string: urlStr) else{
            DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
                self?.myAvAudioDelegate?.unableToPlay()
            }
            
            return
        }
        /*if let volume = curretUser?.preferredVolume{
         let doubleStr = String(format: "%.2f", volume)
         preferredVolume = Float(doubleStr)!
         }*/
        if let volume = UserDefaults.standard.value(forKey: "preferredVolume") as? Float{
            preferredVolume = volume
        }
        //do{
        ////Play or stop audio
        if (!isPlaying){
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    self.avPlayer = try AVAudioPlayer(contentsOf: location)
                    self.playAudio()
                } catch let error as NSError {
                    self.isPlaying = false
                    DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
                        self?.myAvAudioDelegate?.unableToPlay()
                    }
                }
            }).resume()
            
            
            /*
             let data = try Data(contentsOf: url)
             avPlayer = try AVAudioPlayer(data: data)
             avPlayer.prepareToPlay()
             avPlayer.volume = preferredVolume
             avPlayer.delegate = self
             
             avPlayer.play()
             
             myAvAudioDelegate?.startPlay()
             isPlaying = true*/
        }else{
            isPlaying = false
            avPlayer.stop()
            myAvAudioDelegate?.stopPlay()
        }
        /*}catch{
         isPlaying = false
         DispatchQueue.main.asyncAfter(deadline:.now() + 2 ){ [weak self] in
         self?.myAvAudioDelegate?.unableToPlay()
         }
         }*/
        
    }
    
    /*func stopAudioSession(){
     isPlaying = false
     if avPlayer != nil{
     avPlayer.stop()
     }
     }*/
    func playAudio(){
        avPlayer.prepareToPlay()
        avPlayer.volume = preferredVolume
        avPlayer.delegate = self
        
        avPlayer.play()
        
        myAvAudioDelegate?.startPlay()
        isPlaying = true
        //To support media playing in background
        startAudioSession()
    }
    func startAudioSession(){
        do{
            isPlaying = true
            avPlayer.play()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            debugPrint("unable to start session")
        }
    }
    func stopAudioSession(){
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
extension AvAudioHelperClass{
    
    func skipBackward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        
        let interval = command.preferredIntervals[0]
        
        debugPrint(interval) //Output: 42
        
        return .success
    }
}
extension AvAudioHelperClass:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        myAvAudioDelegate?.stopPlay()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        myAvAudioDelegate?.stopPlay()
    }
}
