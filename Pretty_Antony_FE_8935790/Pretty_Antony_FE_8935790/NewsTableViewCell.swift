//
//  NewsTableViewCell.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/7/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelNewsTitle: UILabel!
    
    @IBOutlet weak var labelSource: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var labelAuthor: UILabel!
    
    @IBOutlet weak var newsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
