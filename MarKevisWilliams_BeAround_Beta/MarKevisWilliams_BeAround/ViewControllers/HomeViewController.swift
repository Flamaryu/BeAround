//
//  HomeViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/13/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import EventKit
import EventKitUI

class Section{
    let title: String
    let events: [Event]
    var isOpened: Bool = false
    
    init(title: String, events: [Event],isOpened: Bool = false ){
        self.title = title
        self.events = events
        self.isOpened = isOpened
    }
}
class HomeViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)
    
    var events = [Event]()
    var filteredEvents = [[Event](),[Event](),[Event](),[Event](),[Event](),[Event]()]
    private var sections = [Section]()
    private var searchFilter = [Event]()
    var isSearching = false
    static var goingToEvent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.backgroundColor = .clear
        sections = [
            Section(title: "Fundraiser", events: filteredEvents[0]),
            Section(title: "Technology", events: filteredEvents[1]),
            Section(title: "Cars", events: filteredEvents[2]),
            Section(title: "Meet Ups", events: filteredEvents[3]),
            Section(title: "Parties", events: filteredEvents[4]),
            Section(title: "Community", events: filteredEvents[5]),
        ]
        
        Utilities.FormatLook(self)
        TableView.dataSource = self
        TableView.delegate = self
        TableView.reloadData()
        ObserveEvents()
        
        searchController.definesPresentationContext = true
        searchController.automaticallyShowsSearchResultsController = true
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.barTintColor = .clear
        searchController.searchBar.tintColor = UIColor(rgb: 0xFFCA28)
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.placeholder = "Search by Location"
        //        searchController.searchBar.backgroundColor = .clear
        
        //to recieve the search updates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        
        
        
        // Do any additional setup after loading the view.
    }
    func ShowSomeEvents(){
        if (filteredEvents[0].count < 3){
            sections[0].isOpened = true
            
        }
    }
    
    
    
    func ObserveEvents(){
        let eventRef = Database.database().reference().child("events")
        
        eventRef.observe(.value) { [weak self] snapShot in
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
            
            self?.events = tempEvets
            self?.FilterEvents()
            self?.sections = [
                Section(title: "Fundraiser", events: (self?.filteredEvents[0])!),
                Section(title: "Technology", events: (self?.filteredEvents[1])!),
                Section(title: "Cars", events: (self?.filteredEvents[2])!),
                Section(title: "Meet Ups", events: (self?.filteredEvents[3])!),
                Section(title: "Parties", events: (self?.filteredEvents[4])!),
                Section(title: "Community", events: (self?.filteredEvents[5])!),
            ]
            self?.ShowSomeEvents()
            self?.TableView.reloadData()
        }
        
    }
    
    func FilterEvents(){
        filteredEvents[0] = events.filter({$0.catergory == "Fundraiser"})
        filteredEvents[1] = events.filter({$0.catergory == "Technology"})
        filteredEvents[2] = events.filter({$0.catergory == "Cars"})
        filteredEvents[3] = events.filter({$0.catergory == "Meet Ups"})
        filteredEvents[4] = events.filter({$0.catergory == "Parties"})
        filteredEvents[5] = events.filter({$0.catergory == "Community"})
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isSearching == false{
            if let indexpath = TableView.indexPathForSelectedRow{
                if indexpath.row != 0{
                    let eventToSend = sections[indexpath.section].events[indexpath.row - 1]
                    if let destiation = segue.destination as? EventDetailsViewController{
                        destiation.event = eventToSend
                        print("Event Sent")
                    }
                }
                
            }
        }
        else{
            if let indexpath = TableView.indexPathForSelectedRow{
                let eventToSend = searchFilter[indexpath.row]
                if let destiation = segue.destination as? EventDetailsViewController{
                    destiation.event = eventToSend
                    print("Event Sent")
                }
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching == true{
            return 1
        }
        else{
            return sections.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == false{
            let section  = sections[section]
            
            if section.isOpened == true{
                return section.events.count + 1
            }
            else{
                return 1
            }
        }
        else{
            return searchFilter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching == false{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuseID_00", for: indexPath) as! SectionTableViewCell
                cell.Title.text = sections[indexPath.section].title
                if sections[indexPath.section].isOpened == false{
                    let image = UIImage(systemName: "arrow.up.circle")
                    cell.OpenImage.image = image
                    
                }
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuseID_01", for: indexPath) as! CustomTableViewCell
                cell.set(event: sections[indexPath.section].events[indexPath.row - 1])
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuseID_01", for: indexPath) as! CustomTableViewCell
            cell.set(event: self.searchFilter[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching == false{
            tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 0{
                sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
                
                tableView.reloadSections([indexPath.section], with: .automatic)
                
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching == false{
            if indexPath.row == 0{
                return 50
            }
            else{
                return 125
                
            }
        }
        else{
            return 125
            
        }
    }
    //
    
    
    
}

extension HomeViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //getting the text if user input text
        let searchtext = searchController.searchBar.text
        searchFilter = events
        
        //getting the filterd info
        if searchtext != ""{
            searchFilter = searchFilter.filter({ Event in
                return Event.location.lowercased().contains(searchtext!.lowercased())
            })
        }
        
        //filter for scope
        
        
        TableView.reloadData()
    }
    
    //setting action for when searched is tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        navigationController?.popViewController(animated: true)
        isSearching = true
        TableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        if isSearching{
            isSearching = false
        }
        TableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
        TableView.reloadData()
    }
}
