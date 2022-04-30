//
//  SectionTableViewCell.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/28/22.
//

import UIKit
import FirebaseDatabase

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var OpenImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if isSelected == true{
            let image = UIImage(systemName: "arrow.down.circle")
            OpenImage.image = image
            
        }
        
    }

}
