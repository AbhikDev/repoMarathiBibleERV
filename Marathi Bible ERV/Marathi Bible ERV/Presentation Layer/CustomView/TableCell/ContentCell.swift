//
//  ContentCell.swift
//  Good News Bible app
//
//  Created by Mahesh on 04/01/22.
//

import UIKit

class ContentCell: UITableViewCell {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var lblStory1: UILabel!
    @IBOutlet weak var lblCount1: UILabel!
    @IBOutlet weak var lblStory2: UILabel!
    @IBOutlet weak var lblCount2: UILabel!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var lblContent: BibleVerseLable!
    override func awakeFromNib() {
        super.awakeFromNib()
        if view2 != nil{
            self.view2.makeShadow()
            self.view1.makeShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
