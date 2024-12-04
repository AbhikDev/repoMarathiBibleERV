//
//  DesignableGradientView.swift
//  Rebate
//
//  Created by Abhik Das on 28/04/22.
//

import Foundation

import UIKit

@IBDesignable
class DesignableGradientView: UIView {
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear   { didSet { setNeedsLayout() } }
    
    @IBInspectable var uperColor: UIColor = UIColor.lightGray   { didSet { setNeedsLayout() } }
    
    @IBInspectable var downColor: UIColor = UIColor.darkGray   { didSet { setNeedsLayout() } }
    
    
    @IBInspectable var cornerRadius: CGFloat = -1   { didSet { setNeedsLayout() } }
    
    
    
    @IBInspectable var borderWidth: CGFloat = 3.0  { didSet { setNeedsLayout() } }
    
    @IBInspectable var isMakeShadow: Bool = false  { didSet { setNeedsLayout() } }
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    @IBInspectable var isMakeGradient: Bool = false  { didSet { setNeedsLayout() } }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
        
        layer.cornerRadius = cornerRadius
        if(isMakeGradient){
            let isDarkModeON = UserDefaults.standard.bool(forKey: APP_THEME_MODE)
            if isDarkModeON{
                makeGradient(UIColor(named: "AppGradientDarkModeDarkSide")!, UIColor(named: "AppGradientDarkModeLightSide")!)
            }else{
                makeGradient(UIColor(named: "AppGolden")!, UIColor.yellow)
            }
        }
    }
    func makeGradient(_ topColor : UIColor = UIColor(named: "AppGolden")!, _ bottomColor:UIColor = UIColor.yellow){
        let colorTop = topColor.cgColor
        let colorBottom = bottomColor.cgColor
                    
        let gradientLayer = CAGradientLayer()
        //gradientLayer.type = .radial
        gradientLayer.colors = [colorTop, colorBottom,colorTop]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.7)
        
        //let endY = 0.5 + self.frame.size.width / self.frame.size.height / 2
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.7)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
   
}
