//
//  DesignableButton.swift
//  Good News Bible app
//
//  Created by Abhik Das on 28/12/21.
//

import Foundation
import UIKit
class DesignableButton: UIButton {
    
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
