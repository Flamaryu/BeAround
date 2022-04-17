//
//  CustomTableViewCell.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/16/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var BackGroundView: UIView!
    
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventLocation: UILabel!
    
    @IBOutlet weak var EventDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    weak var event:Event?
    
    func set(event: Event){
        self.event = event
        EventName.text = "Event: \(event.eventName)"
        EventLocation.text = "Address: \(event.location)"
        EventDate.text = "Date: \(event.date)"
    }

}
