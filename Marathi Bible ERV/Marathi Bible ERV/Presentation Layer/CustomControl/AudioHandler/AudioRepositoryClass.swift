//
//  AudioRepositoryClass.swift
//  Good News Bible app
//
//  Created by Abhik Das on 10/01/22.
//

import UIKit
enum AudioHandlerOption{
    case speachToText(text:String,languageCode:String),avAudio(urlString: String)
}
@objc protocol AudioRepositoryClassDelegate {
    func helper_startPlay()
    func helper_stopPlay()
    func helper_unableToPlay()
}

class AudioRepositoryClass :NSObject{
    
    var myAudioDelegate:AudioRepositoryClassDelegate?
    func callAudioByOption(option:AudioHandlerOption){
        switch option{
        case let .speachToText(speachText,lnCode):
            AudioSpeachHelperClass.sharedInstance.hereSpeach(speach: speachText, languageCode: lnCode)
            AudioSpeachHelperClass.sharedInstance.myspeachDelegate = self
            break
        case let .avAudio(urlString):
            AvAudioHelperClass.sharedInstance.setupAudioByUrl(urlStr: urlString)
            AvAudioHelperClass.sharedInstance.myAvAudioDelegate = self
            break
        }
    }
}

////Av Audio delegate Work
extension AudioRepositoryClass : CustomMyAvAudioHelperClassDelegate{
    func unableToPlay() {
        myAudioDelegate?.helper_unableToPlay()
    }
    
    func startPlay() {
        myAudioDelegate?.helper_startPlay()
    }
    
    func stopPlay() {
        myAudioDelegate?.helper_stopPlay()
    }
}

////Speach Delegate work
extension AudioRepositoryClass : CustomSpeachDelegate{
    func startSpeach() {
        myAudioDelegate?.helper_startPlay()
    }
    
    func stopSpeach() {
        myAudioDelegate?.helper_stopPlay()
    }
}
