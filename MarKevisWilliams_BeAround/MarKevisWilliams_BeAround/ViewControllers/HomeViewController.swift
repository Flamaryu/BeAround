//
//  HomeViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/13/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.backgroundColor = .clear
//        TableView.estimatedRowHeight = UITableView.automaticDimension
//        self.view.addSubview(TableView)
        Utilities.FormatLook(self)
        TableView.dataSource = self
        TableView.delegate = self
        TableView.reloadData()
        ObserveEvents()
        
        // Do any additional setup after loading the view.
    }
    
    func ObserveEvents(){
        let eventRef = Database.database().reference().child("events")
        
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
            
            self.events = tempEvets
            self.TableView.reloadData()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func r {
        if let indexpath = TableView.indexPathForSelectedRow{
            let eventToSend = events[indexpath.row]
           if let destiation = segue.destination as? EventDetailsViewController{
               destiation.event = eventToSend
               print("Event Sent")
            }
            
        }
    }

}
extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuseID_01", for: indexPath) as! CustomTableViewCell
        cell.set(event: events[indexPath.row])
        return cell
    }
//
        
    
    
}
