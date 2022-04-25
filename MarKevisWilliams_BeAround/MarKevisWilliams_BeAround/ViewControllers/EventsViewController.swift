//
//  EventsViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/13/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EventsViewController: UIViewController {

    @IBOutlet weak var HostedTV: UITableView!
    
    @IBOutlet weak var AttendingTV: UITableView!
    var hostedEvents = [Event]()
    var attendingEvents = [Event]()
    let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.FormatLook(self)
        HostedTV.dataSource = self
        HostedTV.delegate = self
        AttendingTV.dataSource = self
        AttendingTV.delegate = self
        ObserveEvents()
        HostedTV.backgroundColor = .clear
        AttendingTV.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
   

    func ObserveEvents(){
        
        
        
        let eventRef = Database.database().reference().child("users/profile/\(uid)/hostedEvents")
        let Ref = Database.database().reference().child("users/profile/\(uid)/attendingEvents")
        
        Ref.observe(.value) { snapShot in
            var tempEvets = [Event]()
            
            for child in snapShot.children{
                if let childrenSnapShot = child as? DataSnapshot,
                   let dict = childrenSnapShot.value as? [String:Any],
                   let eventName = dict["eventName"] as? String,
                   let eventLocation = dict["location"] as? String,
                   let catergory = dict["catergory"] as? String,
                   let eventDate = dict["date"] as? String,
                   let description = dict["description"] as? String,
                   let uid = dict["uid"] as? String,
                   let uids = dict["uids"] as? [String]{
                    let event = Event(id: childrenSnapShot.key, eventName: eventName, location: eventLocation, description: description, date: eventDate, catergory: catergory, uid: uid,attendingUID: uids)
                    tempEvets.append(event)
                }
            }
            
            self.attendingEvents = tempEvets
            self.AttendingTV.reloadData()
        }
            
        eventRef.observe(.value) { snapShot in
            var tempEvets = [Event]()
            
           for child in snapShot.children{
               if let childrenSnapShot = child as? DataSnapshot,
                  let dict = childrenSnapShot.value as? [String:Any],
                  let eventName = dict["eventName"] as? String,
                  let eventLocation = dict["location"] as? String,
                  let catergory = dict["catergory"] as? String,
                  let eventDate = dict["date"] as? String,
                  let description = dict["description"] as? String,
                  let uids = dict["uids"] as? [String]{
                   let event = Event(id: childrenSnapShot.key, eventName: eventName, location: eventLocation, description: description, date: eventDate, catergory: catergory, uid: Auth.auth().currentUser!.uid,attendingUID: uids)
                   tempEvets.append(event)
               }
                
            }
            
            self.hostedEvents = tempEvets
            self.HostedTV.reloadData()
        }
        
    }
    
    func removeEvent(_ path: IndexPath){
        //DB ref to remove the event from user later
        let ref = Database.database().reference().child("users/profile/\(uid)/attendingEvents/\(attendingEvents[path.row].id)")
        
        ref.removeValue()
        //DB ref to update child only of the event  might be able to clean up later
        
        let eventRef = Database.database().reference()
        
     let   event =  attendingEvents[path.row]
        if let index = event.attendingUID.firstIndex(of: Auth.auth().currentUser!.uid){
            event.attendingUID.remove(at: index)
        }
        let eventObjct = [
            "eventName": event.eventName,
            "location": event.location,
            "catergory": event.catergory,
            "date": event.date,
            "description": event.description,
            "uid": event.uid,
            "uids": event.attendingUID
            
        ] as [String: Any]
        
        let childUpdate = ["events/\(event.id)": eventObjct]
        eventRef.updateChildValues(childUpdate)
        
    }
   
}
   

extension EventsViewController: UITableViewDelegate, UITableViewDataSource{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == HostedTV{
                return hostedEvents.count
            }
            else{
                return attendingEvents.count
            }
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == HostedTV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_02", for: indexPath) as! CustomTableViewCell
            cell.set(event: hostedEvents[indexPath.row])
               
                
                cell.accessoryType = .detailButton
                return cell
            }
            if tableView == AttendingTV{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_02", for: indexPath) as! CustomTableViewCell
                cell.set(event: attendingEvents[indexPath.row])
                
                cell.accessoryType = .detailButton
                return cell
            }
            return tableView.dequeueReusableCell(withIdentifier: "Cell_02", for: indexPath)
        }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if tableView == HostedTV{
            performSegue(withIdentifier: "editEvent", sender: indexPath)}
        else{
            removeEvent(indexPath)
            print("event removed")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEvent"{
            let indexPath = sender as! IndexPath
            let eventToSend = hostedEvents[indexPath.row]
            let destination = segue.destination as? MakeEventViewController
            destination?.eventEdit = eventToSend
        }
    }
}
