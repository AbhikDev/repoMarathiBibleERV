//
//  HeaderCell.swift
//  Good News Bible app
//
//  Created by Mahesh on 04/01/22.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var gapLayout: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: BibleTitleLable!
    @IBOutlet weak var lblDesc: BibleVerseLable!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
