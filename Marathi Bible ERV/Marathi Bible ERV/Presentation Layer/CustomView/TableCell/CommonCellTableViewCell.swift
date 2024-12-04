//
//  CommonCellTableViewCell.swift


import UIKit
@objc protocol ButtonInstance1Delegate {
    func selectedButton1Instance(cell:UITableViewCell)
}
@objc protocol ButtonInstance2Delegate {
    func selectedButton2Instance(cell:UITableViewCell)
}
class CommonCellTableViewCell: UITableViewCell {
    @IBOutlet weak var lblInfo:UILabel!
    @IBOutlet weak var vwContainer1:UIView!
   
    @IBOutlet weak var imgContent:UIImageView!
   
    @IBOutlet weak var btnInstance1:UIButton!
    @IBOutlet weak var btnInstance2:UIButton!
    
    @IBOutlet weak var mySlider: UISlider!
    
    var btn1Protocol :ButtonInstance1Delegate?
    var btn2Protocol :ButtonInstance2Delegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnInstance1Clicked(_ sender:UIButton){
        btn1Protocol?.selectedButton1Instance(cell: self)
    }
    @IBAction func btnInstance2Clicked(_ sender:UIButton){
        btn2Protocol?.selectedButton2Instance(cell: self)
    }
}
