//
//  SignUpViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstNameFiled: UITextField!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var ConfimrPWDField: UITextField!
    @IBOutlet weak var PWDField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.alpha = 0
        Utilities.FormatLook(self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SingUpTapped(_ sender: Any) {
        let error = Validations()
        if error != nil{
            showError(error!)
        }
        else{
            // creat clean versions of data
            let firstName = self.FirstNameFiled.text!.trimmingCharacters(in:.whitespacesAndNewlines)
            let lastName = self.LastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.EmailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.PWDField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil{
                    self.showError("Error creating User")
                }
                else{
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = "\(firstName) \(lastName)"
                    changeRequest?.commitChanges(completion: { error in
                        if error != nil{
                            self.showError(error!.localizedDescription)
                        }
                        else{
                            let displayName = "\(firstName) \(lastName)"
                            self.saveProfile(displayName: displayName) { success in
                                if success{
                                    self.GoToHome()
                                }
                            }
                        }
                    })
                    
                   
                }
            }
        }
        
    }
    
    func GoToHome(){
        
        let mainTabBarController = storyboard!.instantiateViewController(identifier: "TabbedVC")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)

    }
    func Validations() -> String?{
        if FirstNameFiled.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PWDField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ConfimrPWDField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill out all fields."
        }
        
        let cleanPassword = PWDField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConfirmPasswprd = ConfimrPWDField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = (EmailField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        
        //checking email is corrct format
        if Utilities.isValidEmail(cleanEmail) == false{
            return "Please enter a valid email"
        }
        //checking of passwords match
        if Utilities.isPasswordSame(password: cleanPassword, confirmPassword: cleanConfirmPasswprd) == false{
            ConfimrPWDField.text = nil
            return "Password do not match"
        }
        
        //checking if password is in correct format
        if Utilities.isPasswordValid(cleanPassword) == false{
            return "Password ust contain at least 1 uppercase letter, 1 lowwercase letter, 1 number and one special character "
        }
        
        return nil
    }
    
    func showError(_ error: String){
        ErrorLabel.text = error
        ErrorLabel.alpha = 1
    }

    func saveProfile(displayName:String, completion: @escaping ((_ success:Bool)->())) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let databaseRef = Database.database().reference().child("users/profile/\(uid)")

            let userObject = [
                "displayName": displayName
            ] as [String:Any]

            databaseRef.setValue(userObject) { error, ref in
                completion(error == nil)
            }
        }
    
    
    
}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == PWDField || textField == ConfimrPWDField{
            textField.isSecureTextEntry = false
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == PWDField && !PWDField.isSecureTextEntry) || (textField == ConfimrPWDField && !ConfimrPWDField.isSecureTextEntry){
            textField.isSecureTextEntry = true
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case FirstNameFiled:
            FirstNameFiled.resignFirstResponder()
            LastNameField.becomeFirstResponder()
        case LastNameField:
            LastNameField.resignFirstResponder()
            EmailField.becomeFirstResponder()
        case EmailField:
            EmailField.resignFirstResponder()
            PWDField.becomeFirstResponder()
        case PWDField:
            PWDField.resignFirstResponder()
            ConfimrPWDField.becomeFirstResponder()
        default:
            ConfimrPWDField.resignFirstResponder()
            textField.resignFirstResponder()
        }
        return false
    }
    
}


