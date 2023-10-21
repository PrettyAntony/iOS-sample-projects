//
//  CustomTableViewCell.swift
//  Pretty_Antony_8935790_Sec2Lab6
//
//  Created by user234138 on 10/21/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var buttonDelete: UIButton!
    
    var buttonDeleteAction : (() -> Void)?
    
    @IBAction func isDeleteButtonClicked(_ sender: UIButton) {
        
        buttonDeleteAction?()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
