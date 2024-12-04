//
//  AudioSpeachHelperClass.swift
//  Good News Bible app
//
//  Created by Abhik Das on 09/01/22.
//

import UIKit
import AVFAudio
@objc protocol CustomSpeachDelegate {
    func startSpeach()
    func stopSpeach()
}
class AudioSpeachHelperClass: NSObject {
    static let sharedInstance = AudioSpeachHelperClass()
    var myspeachDelegate:CustomSpeachDelegate?
    
    var speechSynthesizer = AVSpeechSynthesizer()
    var isPlaying = false
    private var preferredVolume:Float = 0.5
    private override init() {
        super.init()
        /*if let volume = curretUser?.preferredVolume{
            let doubleStr = String(format: "%.2f", volume)
            preferredVolume = Float(doubleStr)!
        }*/
        if let volume = UserDefaults.standard.value(forKey: "preferredVolume") as? Float{
            preferredVolume = volume
        }
        speechSynthesizer.delegate = self
    }
    func hereSpeach(speach:String,languageCode:String){
        let utterance = AVSpeechUtterance(string: speach)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)//en-GB")
        utterance.rate = 0.4
        utterance.volume = preferredVolume
        if(speechSynthesizer.isSpeaking){
            speechSynthesizer.stopSpeaking(at: .immediate)
            myspeachDelegate?.stopSpeach()
        }else{
            //speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.speak(utterance)
            myspeachDelegate?.startSpeach()
        }
    }
    func buildUtterance(for volume: Float, with str: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: str)
        utterance.volume = volume
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        return utterance
    }
}
extension AudioSpeachHelperClass : AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying = false
        myspeachDelegate?.stopSpeach()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isPlaying = true
        myspeachDelegate?.startSpeach()
        
    }
}
