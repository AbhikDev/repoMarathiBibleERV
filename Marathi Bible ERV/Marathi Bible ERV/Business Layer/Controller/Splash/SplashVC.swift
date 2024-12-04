//
//  SplashVC.swift
//  Good News Bible app
//
//  Created by Mahesh on 23/01/22.
//

import UIKit

class SplashVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let frameself = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        guard let logoGifImageView = UIImageView.fromGif(frame: frameself, resourceName: "iossplashscreen") else { return }
        self.view.addSubview(logoGifImageView)
        logoGifImageView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            self.appNavigation()
        }
        
    }
    func appNavigation(){
        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
            navigationController?.pushViewController(vc,animated: true)
        }
    }
   
}
