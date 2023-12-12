//
//  HistoryTableViewCell.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/10/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelTypeOfTransaction: UILabel!
    
    @IBOutlet weak var labelCityName: UILabel!
    
    @IBOutlet weak var labelSourceOfTransaction: UILabel!
    
    @IBOutlet weak var labelItem6: UILabel!
    @IBOutlet weak var labelItem5: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
