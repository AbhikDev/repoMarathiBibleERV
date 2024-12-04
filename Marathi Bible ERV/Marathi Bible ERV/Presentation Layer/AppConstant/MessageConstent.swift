

import Foundation
import UIKit
//Some thing
let NETWORK_NOT_REACHABLE = "Internet connection not available"
let NO_DATA = "No Data Found"
let SOME_ERROR = "Something went wrong. Pease try again"
let SELECT_AUDIO_TO_PLAY = "Please select an audio file to play"
let NO_AUDIO = "No audio found"
let AUDIO_ERROR = "Unable to play audio"
let SHUFFLE_SELECTED = "Shuffle has been selected"
let SHUFFLE_DESELECTED = "Shuffle has been cancelled"
let REPEATE_SELECTED = "Repeat mode ON"
let REPEATE_DESELECTED = "Repeat mode OFF"
func showAlertMessageWithActionButton(title: String, message: String, actionButtonText: String,cancelActionButtonText: String, vc: UIViewController, complitionHandeler: @escaping(_ status: Int)-> (Void)){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //alert.view.backgroundColor = APP_THEAM_COLOUR
    alert.addAction(UIAlertAction(title: cancelActionButtonText , style: .default, handler: { (action) in
        
    }))
    alert.addAction(UIAlertAction(title: actionButtonText,
                                      style: .destructive,
                                      handler: {(_: UIAlertAction!) in
                                        complitionHandeler(1)
        }))
        vc.present(alert, animated: true, completion: nil)
}


func showAlertMessage(title: String, message: String,  vc: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}


func showAlertMessageWithOkAction(title: String, message: String, vc: UIViewController, complitionHandeler: @escaping(_ status: Int)-> (Void)){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .destructive,
                                  handler: {(_: UIAlertAction!) in
                                    complitionHandeler(1)
    }))
    vc.present(alert, animated: true, completion: nil)
}
