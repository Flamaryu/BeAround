//
//  MakeEventViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/16/22.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseAuth
import EventKit
import EventKitUI

class MakeEventViewController: UIViewController, EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBOutlet weak var Trash: UIBarButtonItem!
    @IBOutlet weak var AdressTF: UITextField!
    @IBOutlet weak var DescriptionTextView: UITextView!
    @IBOutlet weak var DateTF: UITextField!
    @IBOutlet weak var CatergoryTF: UITextField!
    @IBOutlet weak var EventNameTF: UITextField!
    
    @IBOutlet weak var makeButton: UIButton!
    let eventstore = EKEventStore()
    var ref: DatabaseReference!
    var eventEdit: Event?
    let dateFormatter = DateFormatter()
    
    
    
    let catergories = ["Fundraiser","Technology","Cars","Meet Ups", "Parties","Community"]
    //Pickers
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.FormatLook(self)
        
        // Do any additional setup after loading the view.
        CreatDatePicker()
        CreatPickerView()
        ref = Database.database().reference()
        if eventEdit != nil {
            Trash.isEnabled = true
            AdressTF.text = eventEdit!.location
            EventNameTF.text = eventEdit!.eventName
            DescriptionTextView.text = eventEdit!.description
            DateTF.text = eventEdit!.date
            CatergoryTF.text = eventEdit!.catergory
            makeButton.setTitle("Edit Event", for: .normal)
        }
        else{
            Trash.isEnabled = false
        }
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    func CreatPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let selectButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(SelectedPressed))
        
        toolbar.setItems([selectButton], animated: true)
        CatergoryTF.inputAccessoryView = toolbar
        CatergoryTF.inputView = pickerView
        
    }
    func CreatDatePicker(){
        //makes the bar for done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneButton], animated: true)
        
        DateTF.inputAccessoryView = toolbar
        DateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        
        
    }
    // MARK: Deleting Events
    
    @IBAction func DeleteEvent(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Deleting Event", message: "Once event is deleted it can not be undone!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { delete in
            self.Deleteevent()
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    
    func Deleteevent(){
        //removing event from all profiles that are attending and any chats made to event
        for uid in eventEdit!.attendingUID{
            if uid != eventEdit!.uid{
                let userref =  Database.database().reference().child("users/profile/\(uid)/attendingEvents\(self.eventEdit!.id)")
                let userRef2 = Database.database().reference().child("users/profile/\(uid)/chatRooms/\(self.eventEdit!.id)/post")
                
                userref.removeValue()
                userRef2.removeValue()
            }
            //removing event from host profile
            
            let currentUserRef = Database.database().reference().child("users/profile/\(eventEdit!.uid)/hostedEvents/\(eventEdit!.id)")
            currentUserRef.removeValue()
        }
        
        // removing event from database as a whole
        
        let eventref = Database.database().reference().child("events/\(eventEdit!.id)")
        eventref.removeValue()
        //removing chatroom for event as a whole in database
        let chatref = Database.database().reference().child("chatRoom/\(eventEdit!.id)/post")
        chatref.removeValue()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        DateTF.text = formatter.string(from: datePicker.date)
        DateTF.resignFirstResponder()
        
    }
    @objc func SelectedPressed(){
        CatergoryTF.resignFirstResponder()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func Validation() -> String?{
        if DescriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || DateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || CatergoryTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || AdressTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill out all fields."
        }
        
        return nil
    }
    func showError(_ error: String){
        
    }
    
    @IBAction func MakeEventTapped(_ sender: UIButton) {
        if let error = Validation(){
            showError(error)
        }
        else{
            
            if eventEdit != nil{
                let eventName = EventNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let location = AdressTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let date = DateTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let catergory = CatergoryTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let description = DescriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let uid = eventEdit!.uid
                let uids = eventEdit!.attendingUID
                
                let eventObjct = [
                    "eventName": eventName,
                    "location": location,
                    "catergory": catergory,
                    "date": date,
                    "description": description,
                    "uids": uids,
                    "uid": uid
                ] as [String: Any]
                
                let childupdates = ["events/\(eventEdit!.id)": eventObjct,
                                    "users/profile/\(uid)/hostedEvents/\(eventEdit!.id)" : eventObjct]
                ref.updateChildValues(childupdates) { error, ref in
                    if error != nil{
                        self.showError(error!.localizedDescription)
                    }
                    else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
            else{
                //clean entrties
                let eventName = EventNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let location = AdressTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let date = DateTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let catergory = CatergoryTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let description = DescriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let uid = Auth.auth().currentUser!.uid
                let uids = [uid]
                
                guard let key = Database.database().reference().child("events").childByAutoId().key else{ return}
                
                
                let eventObjct = [
                    "eventName": eventName,
                    "location": location,
                    "catergory": catergory,
                    "date": date,
                    "description": description,
                    "uids": uids,
                    "uid": uid
                ] as [String: Any]
                
                let childupdates = ["events/\(key)": eventObjct,
                                    "users/profile/\(uid)/hostedEvents/\(key)" : eventObjct]
                ref.updateChildValues(childupdates) { error, ref in
                    if error != nil{
                        self.showError(error!.localizedDescription)
                    }
                    else {
                        let  alert = UIAlertController(title: "Add to Calander", message: "Would you like to add event to your calander?", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { cancel in
                            self.navigationController?.popViewController(animated: true)
                        }
                        let yes = UIAlertAction(title: "Yes", style: .default) { yes in
                            self.eventstore.requestAccess(to: .event) { [weak self] success, Error in
                                if success, Error == nil{
                                    DispatchQueue.main.async {
                                        guard let store = self?.eventstore else{return}
                                        
                                        let newEvent = EKEvent(eventStore: store)
                                        newEvent.title = self?.EventNameTF.text!
                                        self?.dateFormatter.dateFormat = "MMM dd, yyyy"
                                        let date = self?.dateFormatter.date(from: (self?.DateTF.text!)!)
                                        newEvent.startDate = date
                                        newEvent.endDate = date
                                        let eventController = EKEventEditViewController()
                                        eventController.editViewDelegate = self
                                        eventController.eventStore = store
                                        eventController.event = newEvent
                                        
                                        self?.present(eventController, animated: true, completion: nil)
                                        
                                        
                                        
                                        
                                    }
                                }
                            }
                            
                            
                        }
                        alert.addAction(yes)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func CancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MakeEventViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catergories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catergories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CatergoryTF.text = catergories[row]
    }
}


