//
//  DesignableView.swift
//  Good News Bible app
//
//  Created by Abhik Das on 19/01/22.
//

import UIKit

class DesignableView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white   { didSet { setNeedsLayout() } }
    @IBInspectable var cornerRadius: CGFloat = -1   { didSet { setNeedsLayout() } }

    
   
    @IBInspectable var borderWidth: CGFloat = 3.0  { didSet { setNeedsLayout() } }
    
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
      
        let maxCornerRadius = min(bounds.width, bounds.height) / 2

        
        if cornerRadius < 0 || cornerRadius > maxCornerRadius {
            layer.cornerRadius = maxCornerRadius
        } else {
            layer.cornerRadius = cornerRadius
        }
    }
}

extension UIView {
    func makeRound(){
        let radius = (self.frame.size.width / 2)
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
    
    func makeRoundCornerRadius(borderWidth:CGFloat,borderColor:UIColor){
        let radius = 5
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
    
    func makeShadow() {
        // Initialization code
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(named: "AppBlack")?.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
    }
    
    
}
