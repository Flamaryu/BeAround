//
//  CustomTableViewCell.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/16/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CustomTableViewCell: UITableViewCell {
    var ref = Database.database().reference()
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

    weak var event:Event?
    
    func set(event: Event){
        self.event = event
        EventName.text = "Event: \(event.eventName)"
        EventLocation.text = "Address: \(event.location)"
        EventDate.text = "Date: \(event.date)"
        if AttendCountLabel != nil{
            AttendCountLabel.text = String(event.attendingUID.count - 1)}
    }

    @IBAction func AttendEvent(_ sender: Any) {
        if !event!.attendingUID.contains(Auth.auth().currentUser!.uid){
            event!.attendingUID.append(Auth.auth().currentUser!.uid)
            let eventObjct = [
                "eventName": event!.eventName,
                "location": event!.location,
                "catergory": event!.catergory,
                "date": event!.date,
                "description": event!.description,
                "uids": event!.attendingUID,
                "uid": event!.uid
            ] as [String: Any]
            
            let childupdates = ["events/\(event!.id)": eventObjct,
                                "users/profile/\(Auth.auth().currentUser!.uid)/attendingEvents/\(event!.id)" : eventObjct]
            ref.updateChildValues(childupdates) {  error, ref in
                if error != nil{
                   print(error!.localizedDescription)
                }else { return}
            }
        }
    }
}
