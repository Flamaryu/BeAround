//
//  MakeEventViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/16/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MakeEventViewController: UIViewController {
    
    @IBOutlet weak var AdressTF: UITextField!
    @IBOutlet weak var DescriptionTextView: UITextView!
    @IBOutlet weak var DateTF: UITextField!
    @IBOutlet weak var CatergoryTF: UITextField!
    @IBOutlet weak var EventNameTF: UITextField!
    
    let catergories = ["Fundraiser","Technology","Cars","Meet Ups", "Parties","Community"]
    //Pickers
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    let editEvent: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.FormatLook(self)
        // Do any additional setup after loading the view.
        CreatDatePicker()
        CreatPickerView()
        
       
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
            //clean entrties
            let eventName = EventNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let location = AdressTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = DateTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let catergory = CatergoryTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let description = DescriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let uids: [String] = [Auth.auth().currentUser!.uid]
            
             let eventRef = Database.database().reference().child("events").childByAutoId()
            
            let eventObjct = [
                "eventName": eventName,
                "location": location,
                "catergory": catergory,
                "date": date,
                "description": description,
                "uids": uids
            ] as [String: Any]
            
            eventRef.setValue(eventObjct) { error, ref in
                if error != nil{
                    self.showError(error!.localizedDescription)
                }
                else{
                    self.navigationController?.popViewController(animated: true)
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
