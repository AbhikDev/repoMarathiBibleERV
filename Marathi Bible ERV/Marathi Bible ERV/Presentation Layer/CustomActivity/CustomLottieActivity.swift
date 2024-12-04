//
//  CustomLottieActivity.swift
//  English Bible
//
//  Created by Abhik Das on 19/07/22.
//

import UIKit
import Lottie
class CustomLottieActivity: UIView {
    
    @IBOutlet var view: UIView?
    @IBOutlet var vwContainer: UIView!
    // 1. Create the AnimationView
    private var animationView: LottieAnimationView?//AnimationView?
    static let sharedInstance = CustomLottieActivity()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setup()
    }
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() -> Void {
        self.view = Bundle.main.loadNibNamed("CustomLottieActivity", owner: self, options: nil)?.first as! UIView?
        self.view?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.addSubview(self.view!)
    }
    func display(onView vw:UIView!,done:@escaping ()->()){
        
        if((self.viewWithTag(1000)) == nil){
            (self.viewWithTag(1000))?.removeFromSuperview()
        }
        if let _ = vw{
            vw.isUserInteractionEnabled = false
            
            let frame = CGRect(x: 0, y: 0, width: vw.frame.size.width, height: vw.frame.size.height)
            self.frame = frame
            self.tag = 1000
            
            
            animationView = .init(name: "bookslottie")
            
            animationView!.frame = vwContainer.bounds
            
            if let ht =  animationView?.frame.size.height{
                animationView?.frame.size.height =  ht
            }
            if let wt =  animationView?.frame.size.width{
                animationView?.frame.size.width =  wt
            }
            // 3. Set animation content mode
            
            animationView!.contentMode = .scaleAspectFit//scaleAspectFit
            
            // 4. Set animation loop mode
            
            animationView!.loopMode = .loop
            
            // 5. Adjust animation speed
            
            animationView!.animationSpeed = 0.5
            animationView?.tag = 2000
            vwContainer.addSubview(animationView!)
            vwContainer.bringSubviewToFront(animationView!)
            vw.addSubview(self)
            vw.bringSubviewToFront(self)
            // 6. Play animation
            animationView?.backgroundColor = .clear
            animationView!.play()
        }
    }
    
    func hide(_:@escaping ()->()){
        self.superview?.isUserInteractionEnabled = true
        self.removeFromSuperview()
        if((self.viewWithTag(1000)) != nil){
            (self.viewWithTag(1000))?.removeFromSuperview()
        }
        if let vw = vwContainer,let anim = animationView{
            anim.stop()
            if((vw.viewWithTag(2000)) != nil){
                (vw.viewWithTag(2000))?.removeFromSuperview()
            }
        }
        /*
         if let activity = activityIndicator{
         activity.superview?.superview?.isUserInteractionEnabled = true
         activity.stopAnimating()
         activity.removeFromSuperview()
         vwContainer?.removeFromSuperview()
         }*/
    }
}
