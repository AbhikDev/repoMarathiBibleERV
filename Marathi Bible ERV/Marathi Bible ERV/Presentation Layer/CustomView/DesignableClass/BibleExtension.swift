//
//  BibleExtension.swift
//  Good News Bible app
//
//  Created by Mahesh on 02/01/22.
//

import Foundation
import UIKit

class BibleHomeLable:UILabel{
    var sizeFixed:Int = 13
    var fontSize :Int {
        get {
            return 13
            }
        set (newValue){
            sizeFixed = fontSize + (newValue - 2)
            self.font = UIFont.systemFont(ofSize: CGFloat(sizeFixed), weight: .medium)
        }
    }
}
class BibleVerseLable:UILabel{
    var sizeFixed:Int = 13
    var fontSize :Int {
        get {
            return 13
            }
        set (newValue){
            sizeFixed = fontSize + (newValue - 2)
            self.font = UIFont.systemFont(ofSize: CGFloat(sizeFixed), weight: .regular)
        }
    }
}
class BibleTitleLable:UILabel{
    var sizeFixed:Int = 15
    var fontSize :Int {
        get {
            return 15
            }
        set (newValue){
            sizeFixed = fontSize + (newValue - 2)
            self.font = UIFont.systemFont(ofSize: CGFloat(sizeFixed), weight: .medium)
        }
    }
}
class BibleHomeView:UIView{
    
}
extension BibleHomeView{
    func toggleTheme(_ selected : Bool){
        if selected{
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark{
                    self.backgroundColor = UIColor.black
                }else{
                    self.backgroundColor = UIColor.white
                }
            } else {
                 self.backgroundColor = UIColor.white
            }

        }else{
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark{
                    self.backgroundColor = UIColor.black
                }else{
                    self.backgroundColor = UIColor.white
                }
            } else {
                 self.backgroundColor = UIColor.white
            }

        }
    }
}
extension BibleHomeLable{

    func toggleTheme(_ selected : Bool){
        if selected{
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark{
                    self.textColor = UIColor.white
                }else{
                    self.textColor = UIColor.darkGray
                }
            } else {
                 self.textColor = UIColor.darkGray
            }

        }else{
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark{
                    self.textColor = UIColor.white
                }else{
                    self.textColor = UIColor.darkGray
                }
            } else {
                 self.textColor = UIColor.darkGray
            }

        }
    }

}
extension UIButton {
    func makeButtonCornerRadius(){
       let radius = (self.frame.size.height / 2)
           self.layer.cornerRadius = radius
           self.clipsToBounds = true
       }
    func makeBorderWithColor(borderWidth:CGFloat,borderColor:UIColor){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
    
}

extension NSAttributedString{
    internal convenience init?(html: String) {
        let modifiedFontString = "<span style=\"font-family: Lato-Regular; font-size: 17\">" + html + "</span>"
        guard let data = modifiedFontString
                .data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
     
        guard let attributedString = try?  NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString: attributedString)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func replace(string:String, replacement:String) -> String {
            return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
        }
}
extension Array {
    var data:Data? {
        get{
            do{
                return (try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted))
            }catch let e {
                print(e.localizedDescription)
                return nil
            }
        }
    }
    
}
extension Double {
    
    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    func secondsToString() -> String {
        return formatter.string(from: self) ?? ""
    }
    
}

extension UILabel {
    func hyperLink(originalText: NSMutableAttributedString,isunderLine:Bool,isfav:Bool) {
        let fullRange = NSMakeRange(0, originalText.length)
        originalText.setAttributes([:], range: fullRange)
        if isunderLine == false {
            originalText.removeAttribute(.underlineStyle,
                                         range: fullRange)
     originalText.removeAttribute(.underlineColor,range: fullRange)
        }else{
            originalText.addAttribute(.underlineStyle,
                                                value: NSUnderlineStyle.single.rawValue,
                                                range: fullRange)
            originalText.addAttribute(.underlineColor,value: UIColor.black,range: fullRange)
          
        }
        if isfav{
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "heartred.png")
            let image1String = NSAttributedString(attachment: image1Attachment)
            originalText.append(image1String)

        }else{
            
        }
        self.attributedText = originalText
    }
}
extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}
