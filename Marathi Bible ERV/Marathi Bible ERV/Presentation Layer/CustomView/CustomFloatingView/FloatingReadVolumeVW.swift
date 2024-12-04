//
//  FloatingReadVolumeVW.swift
//  Good News Bible app
//
//  Created by Abhik Das on 30/12/21.
//

import UIKit
@objc protocol FloatingReadVolumeVWDelegate {
    func GetSelectedFloatingReadVolumeVWIndex(Index:Int)
}
class FloatingReadVolumeVW: UIView {
    var myFloatingReadVolumeVWDelegate:FloatingReadVolumeVWDelegate?
    
    @IBOutlet var view: UIView?
    @IBOutlet var btn_Reader: UIButton?
    @IBOutlet var btn_volume: UIButton?
    func setup() -> Void {
        self.view = Bundle.main.loadNibNamed("FloatingReadVolumeVW", owner: self, options: nil)?.first as! UIView?
        self.view?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        //self.btn_Reader?.makeButtonCornerRadius()
        //self.btn_Reader?.makeBorderWithColor(borderWidth: 3.0, borderColor: .gray)
        self.changeReadBTNAppearence(alpha: 0.0, animated: true)
        self.addSubview(self.view!)
        
    }
    func changeReadBTNAppearence(alpha:CGFloat, animated: Bool){
        
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        //self.btn_Reader?.isHidden = true
        
        UIView.animate(withDuration: duration, animations: {
            
        }, completion: { (true) in
            self.btn_Reader?.alpha = alpha
            //self.btn_Reader?.isHidden = hidden
        })
        
    }
    
    @IBAction func selectionFloatingTabbar(_ sender: UIButton){
        myFloatingReadVolumeVWDelegate?.GetSelectedFloatingReadVolumeVWIndex(Index: sender.tag)
    }
}
