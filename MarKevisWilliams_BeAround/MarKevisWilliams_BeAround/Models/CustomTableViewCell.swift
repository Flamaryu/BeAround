//
//  CustomTableViewCell.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/16/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var BackGroundView: UIView!
    
    @IBOutlet weak var AttendCountLabel: UILabel!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventLocation: UILabel!
    
    @IBOutlet weak var EventDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func AttendTapped(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    weak var event:Event?
    
    func set(event: Event){
        self.event = event
        EventName.text = "Event: \(event.eventName)"
        EventLocation.text = "Address: \(event.location)"
        EventDate.text = "Date: \(event.date)"
        if event.uid.count >= 2{
            AttendCountLabel.text = (event.uid.count - 1).description
            AttendCountLabel.alpha = 1
        }
        else {
            AttendCountLabel.alpha = 0
        }
    }

}
